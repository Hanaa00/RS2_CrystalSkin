namespace CrystalSkin.Services;

public interface IDropdownService
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetGendersAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetPaymentStatusesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetPaymentTypesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetOrderStatusesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetReportTypesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetAppointmentStatusesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetCitiesAsync(int? countryId);
    Task<IEnumerable<KeyValuePair<int, string>>> GetCountriesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetEmployeesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetPatientsAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetServicesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetProductCategoriesAsync();
}