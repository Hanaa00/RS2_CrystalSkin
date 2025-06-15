namespace CrystalSkin.Services;

public class OrderItemsService : BaseService<OrderItem, int, OrderItemModel, OrderItemUpsertModel, BaseSearchObject>, IOrderItemsService
{
    public OrderItemsService(IMapper mapper, IValidator<OrderItemUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }
}
