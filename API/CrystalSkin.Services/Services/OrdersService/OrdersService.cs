
using CrystalSkin.Core;
using CrystalSkin.Services.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace CrystalSkin.Services;

public class OrdersService : BaseService<Order, int, OrderModel, OrderUpsertModel, OrderSearchObject>, IOrdersService
{
    private readonly IHubContext<NotificationHub> _hubContext;


    public OrdersService(
        IMapper mapper,
        IValidator<OrderUpsertModel> validator,
        DatabaseContext databaseContext,
        IHubContext<NotificationHub> hubContext
        ) : base(mapper, validator, databaseContext)
    {
        _hubContext = hubContext;
    }

    public override async Task<PagedList<OrderModel>> GetPagedAsync(OrderSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(p => p.Items)
                .ThenInclude(p => p.Product)
            .Where(o =>
                (
                    string.IsNullOrEmpty(searchObject.SearchFilter)
                    || o.Id.ToString().Contains(searchObject.SearchFilter.ToLower())
                    || (!string.IsNullOrEmpty(o.FullName) && o.FullName.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                    || (o.Patient.FirstName + " " + o.Patient.LastName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (o.Patient.LastName + " " + o.Patient.FirstName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (!string.IsNullOrEmpty(o.TransactionId) && o.TransactionId.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                    || o.Items.Any(i => i.Product.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                )
                && (searchObject.Status == null || searchObject.Status == o.Status)
                && (searchObject.UserId == null || searchObject.UserId == 0 || searchObject.UserId == o.PatientId)
                && !o.IsDeleted
            )
            .OrderByDescending(o => o.Date)
            .ToPagedListAsync(searchObject, cancellationToken);
        return Mapper.Map<PagedList<OrderModel>>(pagedList);
    }

    public async Task<bool> CancelOrderAsync(int orderId, CancellationToken cancellationToken = default)
    {
        var order = await DatabaseContext.Orders.FindAsync(orderId);
        if (order == null)
        {
            throw new ArgumentException("Order not found");
        }

        if (order.Status != OrderStatus.Pending)
        {
            return false;
        }

        order.Status = OrderStatus.Cancelled;
        await DatabaseContext.SaveChangesAsync(cancellationToken);
        return true;
    }

    public Task<int> Count(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => !x.IsDeleted && x.Status != OrderStatus.Cancelled).CountAsync(cancellationToken);
    }

    public async Task<bool> ChangeStatusAsync(int orderId, int requestByUserId, OrderStatus status, bool sendNotification, CancellationToken cancellationToken = default)
    {
        var order = await DatabaseContext.Orders.FindAsync(orderId, cancellationToken);
        if (order == null)
        {
            throw new ArgumentException("Order not found");
        }

        if (order.PatientId == requestByUserId && order.Status != OrderStatus.Pending)
        {
            return false;
        }

        if (sendNotification)
        {
            var message = string.Empty;

            switch (status)
            {
                case OrderStatus.Pending:
                    message = $"Vaša narudžba #{order.Id} je u obradi.";
                    break;
                case OrderStatus.Sent:
                    message = $"Vaša narudžba #{order.Id} je poslana.";
                    break;
                case OrderStatus.Delivered:
                    message = $"Vaša narudžba #{order.Id} je isporučena.";
                    break;
                case OrderStatus.Cancelled:
                    message = $"Vaša narudžba #{order.Id} je otkazana.";
                    break;
                default:
                    break;
            }

            await _hubContext.Clients.Group($"user_{order.PatientId}").SendAsync("ReceiveNotification", new
            {
                Id = order.Id,
                Message = message,
                SentDate = DateTime.Now,
            }, cancellationToken);

            var notification = new Notification()
            {
                UserId = order.PatientId,
                Message = message
            };

            await DatabaseContext.AddAsync(notification);
        }

        order.Status = status;
        await DatabaseContext.SaveChangesAsync(cancellationToken);
        return true;
    }
}
