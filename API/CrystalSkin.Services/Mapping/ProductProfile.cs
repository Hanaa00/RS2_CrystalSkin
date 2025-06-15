namespace CrystalSkin.Services.Mapping;

public class ProductProfile : BaseProfile
{
    public ProductProfile()
    {
        CreateMap<Product, ProductModel>();
        CreateMap<ProductUpsertModel, Product>();
    }
}
