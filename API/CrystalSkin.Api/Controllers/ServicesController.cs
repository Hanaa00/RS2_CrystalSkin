namespace CrystalSkin.Api.Controllers;

//[Authorize(AuthenticationSchemes = "Bearer")]
public class ServicesController : BaseCrudController<ServiceModel, ServiceUpsertModel, BaseSearchObject, IServicesService>
{
    public ServicesController(
        IServicesService service,
        IMapper mapper,
        ILogger<ServicesController> logger,
        IActivityLogsService activityLogs) : base(service, logger, activityLogs)
    {

    }
}
