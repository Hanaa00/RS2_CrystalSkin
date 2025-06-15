namespace CrystalSkin.Services;

public interface IReportsService
{
    Task<byte[]> GeneratePatientsReport(UsersSearchObject searchObject);
    Task<byte[]> GenerateOrdersReport(OrderSearchObject searchObject);
}
