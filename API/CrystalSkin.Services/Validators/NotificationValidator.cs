namespace CrystalSkin.Services.Validators;

public class NotificationValidator : AbstractValidator<NotificationUpsertModel>
{
    public NotificationValidator()
    {
        RuleFor(c => c.Message).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
    }
}
