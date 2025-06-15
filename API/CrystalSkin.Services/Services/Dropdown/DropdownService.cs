namespace CrystalSkin.Services;

public class DropdownService : IDropdownService
{
    private readonly ICountriesService _countriesService;
    private readonly ICitiesService _citiesService;
    private readonly IUsersService _usersService;
    private readonly IServicesService _servicesService;
    private readonly IProductCategoriesService _productCategoriesService;

    public DropdownService(
        ICitiesService citiesService,
        ICountriesService countriesService,
        IUsersService usersService,
        IServicesService servicesService,
        IProductCategoriesService productCategoriesService
        )
    {
        _countriesService = countriesService;
        _citiesService = citiesService;
        _usersService = usersService;
        _servicesService = servicesService;
        this._productCategoriesService = productCategoriesService;
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetGendersAsync() => await Task.FromResult(GetValues<Gender>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetPaymentStatusesAsync() => await Task.FromResult(GetValues<PaymentStatus>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetPaymentTypesAsync() => await Task.FromResult(GetValues<PaymentType>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetOrderStatusesAsync() => await Task.FromResult(GetValues<OrderStatus>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetReportTypesAsync() => await Task.FromResult(GetValues<ReportType>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetAppointmentStatusesAsync() => await Task.FromResult(GetValues<AppointmentStatus>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetCitiesAsync(int? countryId) => await _citiesService.GetDropdownItems(countryId);
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetCountriesAsync() => await _countriesService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetEmployeesAsync() => await _usersService.GetEmployeesDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetPatientsAsync() => await _usersService.GetPatientsDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetServicesAsync() => await _servicesService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetProductCategoriesAsync() => await _productCategoriesService.GetDropdownItems();

    private IEnumerable<KeyValuePair<int, string>> GetValues<T>() where T : Enum
    {
        return Enum.GetValues(typeof(T))
                   .Cast<int>()
                   .Select(e => new KeyValuePair<int, string>(e, Enum.GetName(typeof(T), e)!));
    }
}
