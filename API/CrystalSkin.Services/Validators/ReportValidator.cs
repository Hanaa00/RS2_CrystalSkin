namespace CrystalSkin.Services.Validators;

public class ReportValidator : AbstractValidator<ReportUpsertModel>
{
    public ReportValidator()
    {
        RuleFor(c => c.Data).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => (int)c.Type).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
    }
}
