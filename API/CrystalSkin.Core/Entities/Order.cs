namespace CrystalSkin.Core;

public class Order : BaseEntity
{
    public int PatientId { get; set; }
    public User Patient { get; set; } = default!;
    public string? TransactionId { get; set; }
    public string? FullName { get; set; }
    public string? Address { get; set; }
    public string? PhoneNumber { get; set; }
    public string? PaymentMethod { get; set; }
    public string? DeliveryMethod { get; set; }
    public string? Note { get; set; }
    public decimal TotalAmount { get; set; }
    public OrderStatus Status { get; set; }
    public DateTime? Date { get; set; }
    public ICollection<OrderItem> Items { get; set; } = [];
}
