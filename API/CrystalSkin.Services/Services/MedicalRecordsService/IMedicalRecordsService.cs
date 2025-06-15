namespace CrystalSkin.Services;

public interface IMedicalRecordsService : IBaseService<int, MedicalRecordModel, MedicalRecordUpsertModel, BaseSearchObject>
{
    Task<MedicalRecordModel> GetUserMedicalRecordAsync(int userId);
}
