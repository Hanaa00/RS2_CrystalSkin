namespace CrystalSkin.Services.Mapping;

public class UserProfile : BaseProfile
{
    public UserProfile()
    {
        CreateMap<User, UserModel>();
        CreateMap<UserUpsertModel, User>();

        CreateMap<RegistrationModel, UserUpsertModel>();
    }
}
