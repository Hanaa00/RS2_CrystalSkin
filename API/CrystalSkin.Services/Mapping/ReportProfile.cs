namespace CrystalSkin.Services.Mapping;

public class ReportProfile : BaseProfile
{
    public ReportProfile()
    {
        CreateMap<Report, ReportModel>();
        CreateMap<ReportUpsertModel, Report>();
    }
}
