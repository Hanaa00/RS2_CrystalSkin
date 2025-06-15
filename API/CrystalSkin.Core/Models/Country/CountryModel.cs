namespace CrystalSkin.Core.Models;

public class CountryModel : BaseModel
{
    public string Name { get; set; } = default!;
    public string Abrv { get; set; } = default!;
    public bool IsActive { get; set; }
}
