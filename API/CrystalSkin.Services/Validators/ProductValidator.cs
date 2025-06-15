namespace CrystalSkin.Services.Validators;

public class ProductValidator : AbstractValidator<ProductUpsertModel>
{
    public ProductValidator()
    {
        RuleFor(c => c.Price).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
        RuleFor(c => c.Name).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.ProductCategoryId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
    }
}
