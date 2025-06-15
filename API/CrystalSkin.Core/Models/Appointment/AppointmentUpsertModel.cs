using CrystalSkin.Core.Models.Service;

namespace CrystalSkin.Core.Models;

public class AppointmentUpsertModel : BaseUpsertModel
{
    public int PatientId { get; set; }
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public DateTime BirthDate { get; set; }
    public int EmployeeId { get; set; }
    public DateTime DateTime { get; set; }
    public TimeSpan Duration { get; set; }
    public int ServiceId { get; set; }
    public ServiceUpsertModel? Service { get; set; }
    public AppointmentStatus Status { get; set; }
    public string? RoomNumber { get; set; }
    public string? Location { get; set; }
    public string? Notes { get; set; }
}
