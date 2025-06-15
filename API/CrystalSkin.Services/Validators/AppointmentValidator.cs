namespace CrystalSkin.Services.Validators;

public class AppointmentValidator : AbstractValidator<AppointmentUpsertModel>
{
    public AppointmentValidator()
    {
        RuleFor(c => c.ServiceId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Status).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}
