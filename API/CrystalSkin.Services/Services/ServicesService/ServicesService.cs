namespace CrystalSkin.Services.Services.ServicesService;

public class ServicesService : BaseService<Service, int, ServiceModel, ServiceUpsertModel, BaseSearchObject>, IServicesService
{
    public ServicesService(IMapper mapper, IValidator<ServiceUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet.Select(c => new KeyValuePair<int, string>(c.Id, $"{c.Name} - {c.Duration.TotalMinutes} min")).ToListAsync();
    }
}
