namespace CrystalSkin.Core;

public class OrderItem : BaseEntity
{
    public int OrderId { get; set; }
    public Order Order { get; set; } = default!;
    public int ProductId { get; set; }
    public Product Product { get; set; } = default!;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice => Quantity * UnitPrice;
    public string? Notes { get; set; }
}
