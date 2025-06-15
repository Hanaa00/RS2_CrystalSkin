namespace CrystalSkin.Services.Mapping;

public class ProductCategoryProfile : BaseProfile
{
    public ProductCategoryProfile()
    {
        CreateMap<ProductCategory, ProductCategoryModel>();
        CreateMap<ProductCategoryUpsertModel, ProductCategory>();
    }
}
