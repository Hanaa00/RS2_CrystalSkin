namespace CrystalSkin.Services;

public interface IOrdersService : IBaseService<int, OrderModel, OrderUpsertModel, OrderSearchObject>
{
    Task<int> Count(CancellationToken cancellationToken = default);
    Task<bool> ChangeStatusAsync(int orderId, int requestByUserId, OrderStatus status, bool sendNotification,CancellationToken cancellationToken = default);
}
