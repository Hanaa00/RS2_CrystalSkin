namespace CrystalSkin.Services.Mapping;

public class RoleProfile : BaseProfile
{
    public RoleProfile()
    {
        CreateMap<Role, RoleModel>();
        CreateMap<RoleUpsertModel, Role>();
    }
}
