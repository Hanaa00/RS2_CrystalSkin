namespace CrystalSkin.Core.Models;

public class CityUpsertModel : BaseUpsertModel
{
    public string Name { get; set; } = default!;
    public string Abrv { get; set; } = default!;
    public int CountryId { get; set; }
    public bool IsActive { get; set; }
}
