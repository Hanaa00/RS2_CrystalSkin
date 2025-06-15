namespace CrystalSkin.Services;

public class ReviewsService : BaseService<Review, int, ReviewModel, ReviewUpsertModel, BaseSearchObject>, IReviewsService
{
    public ReviewsService(IMapper mapper, IValidator<ReviewUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }
}
