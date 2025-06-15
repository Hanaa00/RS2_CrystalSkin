namespace CrystalSkin.Services;

public interface IAppointmentsService : IBaseService<int, AppointmentModel, AppointmentUpsertModel, AppointmentSearchObject>
{
    Task<List<TimeSpan>> GetAvailableTimeSlots(int employeeId, int serviceId, DateTime date, CancellationToken cancellationToken = default);
    Task<int> Count(CancellationToken cancellationToken = default);
    Task<bool> ChangeStatusAsync(int appointmentId, int requestByUserId, AppointmentStatus status, bool sendNotification, CancellationToken cancellationToken = default);
}
