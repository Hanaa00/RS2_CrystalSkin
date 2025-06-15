namespace CrystalSkin.Services.Validators;

public class CityValidator : AbstractValidator<CityUpsertModel>
{
    public CityValidator()
    {
        RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.Abrv).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.IsActive).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.CountryId).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}
