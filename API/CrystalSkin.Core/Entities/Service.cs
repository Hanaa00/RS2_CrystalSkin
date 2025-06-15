namespace CrystalSkin.Core.Entities;

public class Service : BaseEntity
{
    public string Name { get; set; } = default!;
    public TimeSpan Duration { get; set; }
}
