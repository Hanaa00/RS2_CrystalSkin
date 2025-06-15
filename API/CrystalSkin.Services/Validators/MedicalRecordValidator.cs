namespace CrystalSkin.Services.Validators;

public class MedicalRecordValidator : AbstractValidator<MedicalRecordUpsertModel>
{
    public MedicalRecordValidator()
    {
        RuleFor(c => c.Allergies).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Diagnoses).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.Treatments).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
    }
}
