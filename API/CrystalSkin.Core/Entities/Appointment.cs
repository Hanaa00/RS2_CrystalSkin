namespace CrystalSkin.Core;

public class Appointment : BaseEntity
{
    public int PatientId { get; set; }
    public User Patient { get; set; } = default!;
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public DateTime BirthDate { get; set; }
    public int EmployeeId { get; set; }
    public User Employee { get; set; } = default!;
    public DateTime DateTime { get; set; }
    public int ServiceId { get; set; }
    public Service Service { get; set; } = default!;
    public AppointmentStatus Status { get; set; }
    public string? RoomNumber { get; set; }
    public string? Location { get; set; }
    public string? Notes { get; set; }
}
