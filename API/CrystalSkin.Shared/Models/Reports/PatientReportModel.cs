namespace CrystalSkin.Shared;

public class PatientReportModel
{
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public string Email { get; set; } = default!;
    public decimal Height { get; set; }
    public decimal Weight { get; set; }
}
