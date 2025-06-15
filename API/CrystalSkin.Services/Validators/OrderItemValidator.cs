namespace CrystalSkin.Services.Validators;

public class OrderItemValidator : AbstractValidator<OrderItemUpsertModel>
{
    public OrderItemValidator()
    {
        RuleFor(c => c.Quantity).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.UnitPrice).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.OrderId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
        RuleFor(c => c.ProductId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
    }
}
