using CrystalSkin.Core.Models.Service;

namespace CrystalSkin.Core.Models;

public class AppointmentModel : BaseModel
{
    public int PatientId { get; set; }
    public UserModel Patient { get; set; } = default!;
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public DateTime BirthDate { get; set; }
    public int EmployeeId { get; set; }
    public UserModel Employee { get; set; } = default!;
    public DateTime DateTime { get; set; }
    public TimeSpan Duration { get; set; }
    public int ServiceId { get; set; }
    public ServiceModel Service { get; set; } = default!;
    public AppointmentStatus Status { get; set; }
    public string? RoomNumber { get; set; }
    public string? Location { get; set; }
    public string? Notes { get; set; }
}
