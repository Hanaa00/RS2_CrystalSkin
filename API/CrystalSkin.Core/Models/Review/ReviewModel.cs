namespace CrystalSkin.Core.Models;

public class ReviewModel : BaseModel
{
    public int PatientId { get; set; }
    public UserModel Patient { get; set; } = default!;
    public int? AppointmentId { get; set; }
    public AppointmentModel? Appointment { get; set; }
    public int EmployeeId { get; set; }
    public UserModel Employee { get; set; } = default!;
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public DateTime ReviewDate { get; set; }
}
