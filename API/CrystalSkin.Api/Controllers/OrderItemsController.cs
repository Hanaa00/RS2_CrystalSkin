namespace CrystalSkin.Api.Controllers;

//[Authorize(AuthenticationSchemes = "Bearer")]
public class OrderItemsController : BaseCrudController<OrderItemModel, OrderItemUpsertModel, BaseSearchObject, IOrderItemsService>
{
    public OrderItemsController(
        IOrderItemsService service,
        ILogger<OrdersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    { }

}
