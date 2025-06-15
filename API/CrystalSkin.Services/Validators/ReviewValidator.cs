namespace CrystalSkin.Services.Validators;

public class ReviewValidator : AbstractValidator<ReviewUpsertModel>
{
    public ReviewValidator()
    {
        RuleFor(c => c.PatientId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
        RuleFor(c => c.Rating).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
    }
}
