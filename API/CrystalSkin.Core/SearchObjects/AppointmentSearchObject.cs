namespace CrystalSkin.Core.SearchObjects;

public class AppointmentSearchObject : BaseSearchObject
{
    public int UserId { get; set; }
    public AppointmentStatus? Status { get; set; }
    public DateTime? Date { get; set; }
}
