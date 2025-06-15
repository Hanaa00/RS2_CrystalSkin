namespace CrystalSkin.Core.Models;

public class OrderItemModel : BaseModel
{
    public int OrderId { get; set; }
    //public OrderModel Order { get; set; } = default!;
    public int ProductId { get; set; }
    public ProductModel Product { get; set; } = default!;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice => Quantity * UnitPrice;
    public string? Notes { get; set; }
}
