namespace CrystalSkin.Services.Mapping;

public class ReviewProfile : BaseProfile
{
    public ReviewProfile()
    {
        CreateMap<Review, ReviewModel>();
        CreateMap<ReviewUpsertModel, Review>();
    }
}
