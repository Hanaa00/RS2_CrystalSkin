namespace CrystalSkin.Services.Database;

public partial class DatabaseContext : IdentityDbContext<User, Role, int, UserClaim, UserRole, UserLogin, RoleClaim, UserToken>
{
    public DbSet<Appointment> Appointments { get; set; }
    public DbSet<City> Cities { get; set; }
    public DbSet<Country> Countries { get; set; }
    public DbSet<ActivityLog> Logs { get; set; }
    public DbSet<MedicalRecord> MedicalRecords { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderItem> OrderItems { get; set; }
    public DbSet<Product> Products { get; set; }
    public DbSet<ProductCategory> ProductCategories { get; set; }
    public DbSet<Payment> Payments { get; set; }
    public DbSet<Review> Reviews { get; set; }
    public DbSet<Report> Reports { get; set; }
    public DbSet<Service> Services { get; set; }
    public DbSet<Notification> Notifications { get; set; }

    public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
    {

    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        SeedData(modelBuilder);
        ApplyConfigurations(modelBuilder);
    }
}
