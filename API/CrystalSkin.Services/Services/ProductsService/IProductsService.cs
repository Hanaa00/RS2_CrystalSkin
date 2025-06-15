namespace CrystalSkin.Services;

public interface IProductsService : IBaseService<int, ProductModel, ProductUpsertModel, ProductSearchObject>
{
    Task<int> Count(CancellationToken cancellationToken = default);
}
