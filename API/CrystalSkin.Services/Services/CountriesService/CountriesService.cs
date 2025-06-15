namespace CrystalSkin.Services;

public class CountriesService : BaseService<Country, int, CountryModel, CountryUpsertModel, BaseSearchObject>, ICountriesService
{
    public CountriesService(IMapper mapper, IValidator<CountryUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
        //
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet.Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}
