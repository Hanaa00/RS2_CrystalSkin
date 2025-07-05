using CrystalSkin.Services.Database;

namespace CrystalSkin.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class AppointmentsController : BaseCrudController<AppointmentModel, AppointmentUpsertModel, AppointmentSearchObject, IAppointmentsService>
{
    private readonly IAppointmentsService _service;
    private readonly ILogger<AppointmentsController> logger;
    private readonly IActivityLogsService activityLogs;
    private readonly IMapper mapper;

    public AppointmentsController(
        IAppointmentsService service,
        ILogger<AppointmentsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        this._service = service;
        this.logger = logger;
        this.activityLogs = activityLogs;
        this.mapper = mapper;
    }

    [HttpGet]
    [Route("available-time-slots")]
    public async Task<List<TimeSpan>> GetAvailableTimeSlots(int employeeId, int serviceId, DateTime date)
    {
        return await _service.GetAvailableTimeSlots(employeeId, serviceId, date);
    }

    [HttpGet]
    [Route("cancel-appointment/{appointmentId}")]
    public async Task<bool> CancelAppointment(int appointmentId)
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.ChangeStatusAsync(appointmentId, userId, AppointmentStatus.Canceled, false);
    }

    [HttpGet]
    [Route("change-status/{appointmentId}/{status}")]
    public async Task<bool> ChangeStatus(int appointmentId, AppointmentStatus status)
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.ChangeStatusAsync(appointmentId, userId, status, true);
    }
}
