namespace CrystalSkin.Services.Mapping;

public class ServiceProfile : BaseProfile
{
    public ServiceProfile()
    {
        CreateMap<Service, ServiceModel>();
        CreateMap<ServiceUpsertModel, Service>();
    }
}
