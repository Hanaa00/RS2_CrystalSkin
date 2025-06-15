namespace CrystalSkin.Services.Validators;

public class UserValidator : AbstractValidator<UserUpsertModel>
{
    public UserValidator()
    {
        RuleFor(c => c.UserName).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Email).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.PhoneNumber).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Address).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.BirthDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Gender).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}
