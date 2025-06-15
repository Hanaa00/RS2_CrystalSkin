namespace CrystalSkin.Services.Mapping;

public class CityProfile : BaseProfile
{
    public CityProfile()
    {
        CreateMap<City, CityModel>();
        CreateMap<CityUpsertModel, City>();
    }
}
