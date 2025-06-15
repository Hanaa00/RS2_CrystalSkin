using CrystalSkin.Core;
using CrystalSkin.Services.Database;
using CrystalSkin.Services.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace CrystalSkin.Services;

public class AppointmentsService : BaseService<Appointment, int, AppointmentModel, AppointmentUpsertModel, AppointmentSearchObject>, IAppointmentsService
{
    private readonly IHubContext<NotificationHub> _hubContext;

    public AppointmentsService(
        IMapper mapper, 
        IValidator<AppointmentUpsertModel> validator, 
        DatabaseContext databaseContext, 
        IHubContext<NotificationHub> hubContext
        ) : base(mapper, validator, databaseContext)
    {
        _hubContext = hubContext;
    }

    public override async Task<PagedList<AppointmentModel>> GetPagedAsync(AppointmentSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(a => a.Employee)
            .Include(a => a.Patient)
            .Include(a => a.Service)
            .Where(c => 
            
                (searchObject.UserId == 0 || searchObject.UserId == c.PatientId)
                && (
                    string.IsNullOrEmpty(searchObject.SearchFilter)
                    || (c.Patient.FirstName + " " + c.Patient.LastName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (c.Patient.LastName + " " + c.Patient.FirstName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || c.Service.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())
                )
                && (searchObject.Status == null || c.Status == searchObject.Status)
                && (searchObject.Date == null || c.DateTime.Date == searchObject.Date.Value.Date)
                && !c.IsDeleted
            )
            .ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<AppointmentModel>>(pagedList);
    }

    public async Task<List<TimeSpan>> GetAvailableTimeSlots(int employeeId, int serviceId, DateTime date, CancellationToken cancellationToken = default)
    {
        var service = await DatabaseContext.Services.FindAsync(serviceId);
        if (service == null)
        {
            throw new ArgumentException("Service not found");
        }

        TimeSpan serviceDuration = service.Duration;

        var existingAppointments = await DatabaseContext.Appointments
            .Include(a => a.Service)
            .Where(a => a.EmployeeId == employeeId &&
                       a.DateTime.Date == date.Date &&
                       a.Status != AppointmentStatus.Canceled)
            .OrderBy(a => a.DateTime)
            .ToListAsync(cancellationToken);

        TimeSpan workDayStart = new TimeSpan(8, 0, 0);
        TimeSpan workDayEnd = new TimeSpan(16, 0, 0);

        List<TimeSpan> allPossibleSlots = new List<TimeSpan>();
        for (TimeSpan time = workDayStart; time <= workDayEnd - serviceDuration; time = time.Add(new TimeSpan(0, 5, 0)))
        {
            allPossibleSlots.Add(time);
        }

        List<TimeSpan> availableSlots = new List<TimeSpan>();

        foreach (var slot in allPossibleSlots)
        {
            DateTime slotDateTime = date.Date.Add(slot);
            DateTime slotEndDateTime = slotDateTime.Add(serviceDuration);

            bool isAvailable = true;

            foreach (var appointment in existingAppointments)
            {
                DateTime appointmentEnd = appointment.DateTime.Add(appointment.Service.Duration);

                if (slotDateTime < appointmentEnd && slotEndDateTime > appointment.DateTime)
                {
                    isAvailable = false;
                    break;
                }
            }

            if (isAvailable)
            {
                availableSlots.Add(slot);
            }
        }

        return availableSlots;
    }

    public async Task<bool> ChangeStatusAsync(int appointmentId, int requestByUserId, AppointmentStatus status, bool sendNotification, CancellationToken cancellationToken = default)
    {
        var appointment = await DatabaseContext.Appointments.FindAsync(appointmentId, cancellationToken);
        if (appointment == null)
        {
            throw new ArgumentException("Appointment not found");
        }

        if (appointment.PatientId == requestByUserId && appointment.DateTime.Date == DateTime.Today)
        {
            return false;
        }

        if (sendNotification)
        {
            var message = string.Empty;

            switch (status)
            {
                case AppointmentStatus.Scheduled:
                    message = "Vaš termin je zakazan.";
                    break;
                case AppointmentStatus.Canceled:
                    message = "Vaš termin je otkazan.";
                    break;
                case AppointmentStatus.Completed:
                    message = "Vaš termin je realizovan.";
                    break;
                default:
                    break;
            }

            await _hubContext.Clients.Group($"user_{appointment.PatientId}").SendAsync("ReceiveNotification", new
            {
                Id = appointment.Id,
                Message = message,
                SentDate = DateTime.Now,
            }, cancellationToken);

            var notification = new Notification()
            {
                UserId = appointment.PatientId,
                Message = message
            };

            await DatabaseContext.AddAsync(notification, cancellationToken);
        }

        appointment.Status = status;
        await DatabaseContext.SaveChangesAsync(cancellationToken);
        return true;
    }

    public Task<int> Count(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => !x.IsDeleted).CountAsync(cancellationToken);
    }
}
