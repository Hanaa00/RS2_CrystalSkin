namespace CrystalSkin.Services.Validators;

public class PaymentValidator : AbstractValidator<PaymentUpsertModel>
{
    public PaymentValidator()
    {
        RuleFor(c => c.Price).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.OrderId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
        RuleFor(c => c.PatientId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
    }
}
