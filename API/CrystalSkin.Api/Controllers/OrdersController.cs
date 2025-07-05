using CrystalSkin.Core.Entities;

namespace CrystalSkin.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class OrdersController : BaseCrudController<OrderModel, OrderUpsertModel, OrderSearchObject, IOrdersService>
{
    private readonly IOrdersService _service;

    public OrdersController(
        IOrdersService service,
        ILogger<OrdersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        _service = service;
    }

    [HttpGet]
    [Route("cancel-order/{orderId}")]
    public async Task<bool> CancelOrder(int orderId)
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.ChangeStatusAsync(orderId, userId, OrderStatus.Cancelled, false);
    }

    [HttpGet]
    [Route("change-status/{orderId}/{status}")]
    public async Task<bool> ChangeStatus(int orderId, OrderStatus status)
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.ChangeStatusAsync(orderId, userId, status, true);
    }
}
