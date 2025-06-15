namespace CrystalSkin.Api.Controllers;

public class DropdownController : BaseController
{
    private readonly IDropdownService _dropdownService;
    public DropdownController(IDropdownService service, ILogger<DropdownController> logger, IActivityLogsService activityLogs) : base(logger, activityLogs)
    {
        _dropdownService = service;
    }

    [HttpGet]
    [Route("genders")]
    public async Task<IActionResult> Genders()
    {
        var list = await _dropdownService.GetGendersAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("paymentStatuses")]
    public async Task<IActionResult> PaymentStatuses()
    {
        var list = await _dropdownService.GetPaymentStatusesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("paymentTypes")]
    public async Task<IActionResult> PaymentTypes()
    {
        var list = await _dropdownService.GetPaymentTypesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("orderStatuses")]
    public async Task<IActionResult> OrderStatuses()
    {
        var list = await _dropdownService.GetOrderStatusesAsync();
        return Ok(list);
    }


    [HttpGet]
    [Route("reportTypes")]
    public async Task<IActionResult> ReportTypes()
    {
        var list = await _dropdownService.GetReportTypesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("appointmentStatuses")]
    public async Task<IActionResult> AppointmentStatuses()
    {
        var list = await _dropdownService.GetAppointmentStatusesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("cities")]
    public async Task<IActionResult> Cities([FromQuery] int? countryId)
    {
        var list = await _dropdownService.GetCitiesAsync(countryId);
        return Ok(list);
    }

    [HttpGet]
    [Route("countries")]
    public async Task<IActionResult> Countries()
    {
        var list = await _dropdownService.GetCountriesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("employees")]
    public async Task<IActionResult> Employees()
    {
        var list = await _dropdownService.GetEmployeesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("patients")]
    public async Task<IActionResult> Patients()
    {
        var list = await _dropdownService.GetPatientsAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("services")]
    public async Task<IActionResult> Services()
    {
        var list = await _dropdownService.GetServicesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("productCategories")]
    public async Task<IActionResult> ProductCategories()
    {
        var list = await _dropdownService.GetProductCategoriesAsync();
        return Ok(list);
    }
}
