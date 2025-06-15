namespace CrystalSkin.Core.Models;

public class ReviewUpsertModel : BaseUpsertModel
{
    public int PatientId { get; set; }
    public int? AppointmentId { get; set; }
    public int EmployeeId { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public DateTime ReviewDate { get; set; }
}
