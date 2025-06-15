using CrystalSkin.Core.Models.Service;

namespace CrystalSkin.Services.Services.ServicesService;

public interface IServicesService : IBaseService<int, ServiceModel, ServiceUpsertModel, BaseSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
}
