namespace CrystalSkin.Core.Models;

public class NotificationModel : BaseModel
{
    public int UserId { get; set; }
    public UserModel User { get; set; }
    public string Message { get; set; }
    public bool Read { get; set; }
}
