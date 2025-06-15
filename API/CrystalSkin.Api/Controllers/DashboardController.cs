namespace CrystalSkin.Api.Controllers;

//[Authorize(AuthenticationSchemes = "Bearer")]
public class DashboardController : BaseController
{
    private readonly IUsersService _usersService;
    private readonly IAppointmentsService _appointmentService;
    private readonly IProductsService _productsService;
    private readonly IProductCategoriesService _productCategoriesService;
    private readonly IOrdersService _ordersService;
    private readonly IPaymentsService _paymentsService;
    public DashboardController(
        IUsersService usersService,
        IAppointmentsService appointmentsService,
        IProductsService productsService,
        IProductCategoriesService productCategoriesService,
        IOrdersService ordersService,
        IPaymentsService paymentsService,
        IMapper mapper,
        ILogger<DashboardController> logger,
        IActivityLogsService activityLogs) : base(logger, activityLogs)
    {
        _usersService = usersService;
        _appointmentService = appointmentsService;
        _productsService = productsService;
        _productCategoriesService = productCategoriesService;
        _ordersService = ordersService;
        _paymentsService = paymentsService;
    }

    [HttpGet("AdminData")]
    public async Task<IActionResult> GetAdminData(CancellationToken cancellationToken = default)
    {
        try
        {
            var patientsCount = await _usersService.PatientCount(cancellationToken);
            var employeesCount = await _usersService.EmployeeCount(cancellationToken);
            var appointmentsCount = await _appointmentService.Count(cancellationToken);
            var productsCount = await _productsService.Count(cancellationToken);
            var productCategoriesCount = await _productCategoriesService.Count();
            var ordersCount = await _ordersService.Count(cancellationToken);
            var totalPayments = await _paymentsService.TotalPayments(DateTime.Now, cancellationToken);

            return Ok(new
            {
                Patients = patientsCount,
                Employees = employeesCount,
                Appointments = appointmentsCount,
                Products = productsCount,
                ProductCategories = productCategoriesCount,
                Orders = ordersCount,
                TotalPayments = totalPayments
            });
        }
        catch (Exception e)
        {
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, "Dashboard", e);
            return BadRequest(e.Message);
        }
    }
}
