namespace CrystalSkin.Services.Validators;

public class OrderValidator : AbstractValidator<OrderUpsertModel>
{
    public OrderValidator()
    {
        RuleFor(c => c.Status).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.PatientId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
    }
}
