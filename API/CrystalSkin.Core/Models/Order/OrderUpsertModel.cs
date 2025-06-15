namespace CrystalSkin.Core.Models;

public class OrderUpsertModel : BaseUpsertModel
{
    public int PatientId { get; set; }
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
    public ICollection<OrderItemUpsertModel> Items { get; set; } = [];
}
