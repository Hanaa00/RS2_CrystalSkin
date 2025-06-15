using CrystalSkin.Services.Services.RecommendationService;

namespace CrystalSkin.Services;

public static class Registry
{
    public static void AddServices(this IServiceCollection services)
    {
        services.AddScoped<IActivityLogsService, ActivityLogsService>();
        services.AddScoped<IAppointmentsService, AppointmentsService>();
        services.AddScoped<ICitiesService, CitiesService>();
        services.AddScoped<ICountriesService, CountriesService>();
        services.AddScoped<IDropdownService, DropdownService>();
        services.AddScoped<IMedicalRecordsService, MedicalRecordsService>();
        services.AddScoped<IUsersService, UsersService>();
        services.AddScoped<IOrdersService, OrdersService>();
        services.AddScoped<IOrderItemsService, OrderItemsService>();
        services.AddScoped<IPaymentsService, PaymentsService>();
        services.AddScoped<IProductsService, ProductsService>();
        services.AddScoped<IProductCategoriesService, ProductCategoriesService>();
        services.AddScoped<IReportsService, ReportsService>();
        services.AddScoped<IReviewsService, ReviewsService>();
        services.AddScoped<IRolesService, RolesService>();
        services.AddScoped<IRabbitMQProducer, RabbitMQProducer>();
        services.AddScoped<IServicesService, ServicesService>();
        services.AddScoped<INotificationsService, NotificationsService>();
        services.AddScoped<IRecommendationService, RecommendationService>();
    }

    public static void AddValidators(this IServiceCollection services)
    {
        services.AddScoped<IValidator<ActivityLogUpsertModel>, ActivityLogValidator>();
        services.AddScoped<IValidator<AppointmentUpsertModel>, AppointmentValidator>();
        services.AddScoped<IValidator<CityUpsertModel>, CityValidator>();
        services.AddScoped<IValidator<CountryUpsertModel>, CountryValidator>();
        services.AddScoped<IValidator<MedicalRecordUpsertModel>, MedicalRecordValidator>();
        services.AddScoped<IValidator<OrderUpsertModel>, OrderValidator>();
        services.AddScoped<IValidator<OrderItemUpsertModel>, OrderItemValidator>();
        services.AddScoped<IValidator<PaymentUpsertModel>, PaymentValidator>();
        services.AddScoped<IValidator<ProductUpsertModel>, ProductValidator>();
        services.AddScoped<IValidator<ProductCategoryUpsertModel>, ProductCategoryValidator>();
        services.AddScoped<IValidator<ReportUpsertModel>, ReportValidator>();
        services.AddScoped<IValidator<ReviewUpsertModel>, ReviewValidator>();
        services.AddScoped<IValidator<RoleUpsertModel>, RoleValidator>();
        services.AddScoped<IValidator<UserUpsertModel>, UserValidator>();
        services.AddScoped<IValidator<ServiceUpsertModel>, ServiceValidator>();
        services.AddScoped<IValidator<NotificationUpsertModel>, NotificationValidator>();
    }
}
