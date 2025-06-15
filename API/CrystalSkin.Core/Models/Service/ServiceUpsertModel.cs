namespace CrystalSkin.Core.Models.Service;

public class ServiceUpsertModel : BaseUpsertModel
{
    public string Name { get; set; } = default!;
    public TimeSpan Duration { get; set; }
}
