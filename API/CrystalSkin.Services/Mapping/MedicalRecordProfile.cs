namespace CrystalSkin.Services.Mapping;

public class MedicalRecordProfile : BaseProfile
{
    public MedicalRecordProfile()
    {
        CreateMap<MedicalRecord, MedicalRecordModel>();
        CreateMap<MedicalRecordUpsertModel, MedicalRecord>();
    }
}
