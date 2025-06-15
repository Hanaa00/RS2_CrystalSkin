namespace CrystalSkin.Services.Mapping;

public class PaymentProfile : BaseProfile
{
    public PaymentProfile()
    {
        CreateMap<Payment, PaymentModel>();
        CreateMap<PaymentUpsertModel, Payment>();
    }
}
