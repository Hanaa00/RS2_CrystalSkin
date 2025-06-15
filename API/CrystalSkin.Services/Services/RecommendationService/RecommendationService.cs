using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace CrystalSkin.Services.Services.RecommendationService;
public class RecommendationService : IRecommendationService
{
    private readonly DatabaseContext _context;
    private readonly IMapper _mapper;
    private static readonly MLContext _mlContext = new MLContext(seed: 0);
    private static ITransformer? _model;
    private static bool _isTrained = false;

    public RecommendationService(DatabaseContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public void TrainModel()
    {
        if (_isTrained) return;

        var ratings = _context.Orders
            .SelectMany(o => o.Items.Select(i => new ProductRating
            {
                UserId = (uint)o.PatientId,
                ProductId = (uint)i.ProductId,
                Label = i.Quantity
            })).ToList();

        var trainingData = _mlContext.Data.LoadFromEnumerable(ratings);

        var options = new MatrixFactorizationTrainer.Options
        {
            MatrixColumnIndexColumnName = nameof(ProductRating.ProductId),
            MatrixRowIndexColumnName = nameof(ProductRating.UserId),
            LabelColumnName = nameof(ProductRating.Label),
            NumberOfIterations = 30,
            ApproximationRank = 100
        };

        var estimator = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
        _model = estimator.Fit(trainingData);
        _isTrained = true;
    }

    public List<ProductModel> GetTopRecommendationsForUser(int userId, int topN = 5)
    {
        var allProductIds = _context.Products.Select(p => p.Id).ToList();

        var boughtProductIds = _context.Orders
            .Where(o => o.PatientId == userId)
            .SelectMany(o => o.Items.Select(i => i.ProductId))
            .Distinct()
            .ToList();

        var predictionEngine = _mlContext.Model.CreatePredictionEngine<ProductRating, ProductRatingPrediction>(_model!);

        var recommendedProducts = allProductIds
            .Where(p => !boughtProductIds.Contains(p))
            .Select(p => new
            {
                ProductId = p,
                Score = predictionEngine.Predict(new ProductRating
                {
                    UserId = (uint)userId,
                    ProductId = (uint)p
                }).Score
            })
            .OrderByDescending(r => r.Score)
            .Take(topN)
            .Select(r => r.ProductId)
            .ToList();

        var recommendedProductsModels = new List<ProductModel>();

        if (recommendedProducts?.Count > 0) 
        {
            recommendedProductsModels = _context.Products
                .Where(p => recommendedProducts.Contains(p.Id))
                .Select(p => _mapper.Map<ProductModel>(p)).ToList();
        }


        return recommendedProductsModels;
    }
}

public class ProductRating
{
    [KeyType(count: 100)]
    public uint UserId { get; set; }

    [KeyType(count: 100)]
    public uint ProductId { get; set; }

    public float Label { get; set; }
}
public class ProductRatingPrediction
{
    public float Score { get; set; }
}
