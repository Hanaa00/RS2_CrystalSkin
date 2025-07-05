namespace CrystalSkin.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class MedicalRecordsController : BaseCrudController<MedicalRecordModel, MedicalRecordUpsertModel, BaseSearchObject, IMedicalRecordsService>
{
    private readonly IMedicalRecordsService _service;

    public MedicalRecordsController(
        IMedicalRecordsService service,
        ILogger<OrdersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        _service = service;
    }

    [HttpGet]
    [Route("get-user-medical-record")]
    public async Task<MedicalRecordModel> GetUserMedicalRecord()
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.GetUserMedicalRecordAsync(userId);
    }
}
