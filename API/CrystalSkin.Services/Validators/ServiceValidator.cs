using CrystalSkin.Core.Models.Service;
namespace CrystalSkin.Services.Validators;

internal class ServiceValidator : AbstractValidator<ServiceUpsertModel>
{
    public ServiceValidator()
    {
        RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.Duration).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}
