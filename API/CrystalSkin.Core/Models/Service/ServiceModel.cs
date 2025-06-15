namespace CrystalSkin.Core.Models.Service;

public class ServiceModel : BaseModel
{
    public string Name { get; set; } = default!;
    public TimeSpan Duration { get; set; }
}
