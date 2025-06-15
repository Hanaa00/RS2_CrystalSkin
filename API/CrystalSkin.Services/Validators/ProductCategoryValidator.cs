namespace CrystalSkin.Services.Validators;

public class ProductCategoryValidator : AbstractValidator<ProductCategoryUpsertModel>
{
    public ProductCategoryValidator()
    {
        RuleFor(c => c.Name).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}
