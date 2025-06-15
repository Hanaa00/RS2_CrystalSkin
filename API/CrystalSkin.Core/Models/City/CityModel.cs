namespace CrystalSkin.Core.Models;

public class CityModel : BaseModel
{
    public string Name { get; set; } = default!;
    public string Abrv { get; set; } = default!;
    public CountryModel Country { get; set; } = default!;
    public int CountryId { get; set; }
    public bool IsActive { get; set; }
}
