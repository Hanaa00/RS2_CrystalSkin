
namespace CrystalSkin.Services;

public class MedicalRecordsService : BaseService<Order, int, MedicalRecordModel, MedicalRecordUpsertModel, BaseSearchObject>, IMedicalRecordsService
{
    public MedicalRecordsService(IMapper mapper, IValidator<MedicalRecordUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }

    public async Task<MedicalRecordModel> GetUserMedicalRecordAsync(int userId)
    {
        var user = await DatabaseContext.Users.Include(x => x.MedicalRecord).FirstOrDefaultAsync(x => x.Id == userId);

        if (user == null)
        {
            throw new Exception("User not found");
        }

        return Mapper.Map<MedicalRecordModel>(user.MedicalRecord);
    }
}
