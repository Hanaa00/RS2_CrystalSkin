namespace CrystalSkin.Services;

public class RolesService : BaseService<Role, int, RoleModel, RoleUpsertModel, BaseSearchObject>, IRolesService
{
    public RolesService(IMapper mapper, IValidator<RoleUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }
}
