namespace CrystalSkin.Services.Mapping;

public class OrderProfile : BaseProfile
{
    public OrderProfile()
    {
        CreateMap<Order, OrderModel>();
        CreateMap<OrderUpsertModel, Order>();
    }
}
