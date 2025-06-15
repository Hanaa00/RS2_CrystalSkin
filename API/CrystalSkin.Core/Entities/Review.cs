namespace CrystalSkin.Core;

public class Review : BaseEntity
{
    public int PatientId { get; set; }
    public User Patient { get; set; } = default!;
    public int? AppointmentId { get; set; }
    public Appointment? Appointment { get; set; }
    public int EmployeeId { get; set; }
    public User Employee { get; set; } = default!;
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public DateTime ReviewDate { get; set; }

}
