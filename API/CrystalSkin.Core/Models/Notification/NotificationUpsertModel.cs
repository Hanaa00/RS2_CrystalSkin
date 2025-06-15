namespace CrystalSkin.Core.Models;

public class NotificationUpsertModel : BaseUpsertModel
{
    public int UserId { get; set; }
    //public UserUpsertModel User { get; set; }
    public string Message { get; set; }
    public bool Read { get; set; }
}
