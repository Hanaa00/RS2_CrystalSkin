namespace CrystalSkin.Services.Mapping;

public class CountryProfile : BaseProfile
{
    public CountryProfile()
    {
        CreateMap<Country, CountryModel>();
        CreateMap<CountryUpsertModel, Country>();
    }
}
