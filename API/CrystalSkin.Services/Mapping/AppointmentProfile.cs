namespace CrystalSkin.Services.Mapping;

public class AppointmentProfile : BaseProfile
{
    public AppointmentProfile()
    {
        CreateMap<Appointment, AppointmentModel>();
        CreateMap<AppointmentUpsertModel, Appointment>();
    }
}
