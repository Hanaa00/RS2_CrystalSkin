namespace CrystalSkin.Services.Services.RecommendationService;

public interface IRecommendationService
{
    void TrainModel();
    List<ProductModel> GetTopRecommendationsForUser(int userId, int topN = 5);
}
