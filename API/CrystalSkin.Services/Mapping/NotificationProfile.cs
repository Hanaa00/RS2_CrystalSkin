namespace CrystalSkin.Services.Mapping;

public class NotificationProfile : BaseProfile
{
    public NotificationProfile()
    {
        CreateMap<Notification, NotificationModel>();
        CreateMap<NotificationUpsertModel, Notification>();
    }
}
