namespace CrystalSkin.Services;

public class PaymentsService : BaseService<Payment, int, PaymentModel, PaymentUpsertModel, BaseSearchObject>, IPaymentsService
{
    public PaymentsService(IMapper mapper, IValidator<PaymentUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
        //
    }

    public async Task<decimal> TotalPayments(DateTime date, CancellationToken cancellationToken = default)
    {
        return await DbSet
            .Where(x => !x.IsDeleted && x.IsPaid)
            .SumAsync(x => x.Price - x.Price * x.Discount / 100, cancellationToken) ?? Decimal.Zero;
    }
}
