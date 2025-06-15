namespace CrystalSkin.Core;

public class Notification : BaseEntity
{
    public int UserId { get; set; }
    public User User { get; set; }
    public string Message { get; set; }
    public bool Read { get; set; }
}
