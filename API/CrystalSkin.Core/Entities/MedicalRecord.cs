namespace CrystalSkin.Core;

public class MedicalRecord : BaseEntity
{
    public string Diagnoses { get; set; } = default!;
    public string Allergies { get; set; } = default!;
    public string Treatments { get; set; } = default!;
    public string Notes { get; set; } = default!;
    public string BloodType { get; set; } = default!;
    public decimal Height { get; set; } = default!;
    public decimal Weight { get; set; } = default!;
    public int? LastUpdatedByEmployeeId { get; set; }
    public User? LastUpdateByEmployee { get; set; }
}
