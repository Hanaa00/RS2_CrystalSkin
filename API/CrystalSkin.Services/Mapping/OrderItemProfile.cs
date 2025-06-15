namespace CrystalSkin.Services.Mapping;

public class OrderItemProfile : BaseProfile
{
    public OrderItemProfile()
    {
        CreateMap<OrderItem, OrderItemModel>();
        CreateMap<OrderItemUpsertModel, OrderItem>();
    }
}
