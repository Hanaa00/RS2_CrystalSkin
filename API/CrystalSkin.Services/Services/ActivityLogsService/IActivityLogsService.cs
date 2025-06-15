using CrystalSkin.Core;
using CrystalSkin.Core.Models;
using CrystalSkin.Core.SearchObjects;

namespace CrystalSkin.Services
{
    public interface IActivityLogsService : IBaseService<int, ActivityLogModel, ActivityLogUpsertModel, BaseSearchObject>
    {
        Task<List<ActivityLogModel>> LogAsync(ActivityLogType logType, string tableName, Exception ex, IEnumerable<int?> rowIds = null, string email = null);
        Task<ActivityLogModel> LogAsync(ActivityLogType logType, int? rowId, string tableName, Exception? ex, string email = null);
    }
}
