using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace CrystalSkin.Services.Migrations
{
    /// <inheritdoc />
    public partial class Init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    RoleLevel = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Name = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Abrv = table.Column<string>(type: "text", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "MedicalRecords",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Diagnoses = table.Column<string>(type: "text", nullable: false),
                    Allergies = table.Column<string>(type: "text", nullable: false),
                    Treatments = table.Column<string>(type: "text", nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: false),
                    BloodType = table.Column<string>(type: "text", nullable: false),
                    Height = table.Column<decimal>(type: "numeric", nullable: false),
                    Weight = table.Column<decimal>(type: "numeric", nullable: false),
                    LastUpdatedByEmployeeId = table.Column<int>(type: "integer", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MedicalRecords", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ProductCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductCategories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Services",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Duration = table.Column<TimeSpan>(type: "interval", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Services", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Abrv = table.Column<string>(type: "text", nullable: false),
                    CountryId = table.Column<int>(type: "integer", nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Cities_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsFirstLogin = table.Column<bool>(type: "boolean", nullable: false),
                    VerificationSent = table.Column<bool>(type: "boolean", nullable: false),
                    FirstName = table.Column<string>(type: "text", nullable: true),
                    LastName = table.Column<string>(type: "text", nullable: true),
                    BirthDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    Gender = table.Column<int>(type: "integer", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: false),
                    ProfilePhoto = table.Column<string>(type: "text", nullable: true),
                    ProfilePhotoThumbnail = table.Column<string>(type: "text", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    LicenseNumber = table.Column<string>(type: "text", nullable: true),
                    YearsOfExperience = table.Column<int>(type: "integer", nullable: true),
                    WorkingHours = table.Column<string>(type: "text", nullable: true),
                    Position = table.Column<string>(type: "text", nullable: true),
                    CountryId = table.Column<int>(type: "integer", nullable: true),
                    MedicalRecordId = table.Column<int>(type: "integer", nullable: true),
                    UserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    PasswordHash = table.Column<string>(type: "text", nullable: true),
                    SecurityStamp = table.Column<string>(type: "text", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUsers_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AspNetUsers_MedicalRecords_MedicalRecordId",
                        column: x => x.MedicalRecordId,
                        principalTable: "MedicalRecords",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    Price = table.Column<decimal>(type: "numeric", nullable: false),
                    Stock = table.Column<int>(type: "integer", nullable: false),
                    ImageUrl = table.Column<string>(type: "text", nullable: false),
                    IsEnable = table.Column<bool>(type: "boolean", nullable: false),
                    Manufacturer = table.Column<string>(type: "text", nullable: true),
                    Barcode = table.Column<string>(type: "text", nullable: true),
                    Ingredients = table.Column<string>(type: "text", nullable: true),
                    ProductCategoryId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Products_ProductCategories_ProductCategoryId",
                        column: x => x.ProductCategoryId,
                        principalTable: "ProductCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Appointments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    PatientId = table.Column<int>(type: "integer", nullable: false),
                    FirstName = table.Column<string>(type: "text", nullable: false),
                    LastName = table.Column<string>(type: "text", nullable: false),
                    BirthDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    EmployeeId = table.Column<int>(type: "integer", nullable: false),
                    DateTime = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    ServiceId = table.Column<int>(type: "integer", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    RoomNumber = table.Column<string>(type: "text", nullable: true),
                    Location = table.Column<string>(type: "text", nullable: true),
                    Notes = table.Column<string>(type: "text", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Appointments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Appointments_AspNetUsers_EmployeeId",
                        column: x => x.EmployeeId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Appointments_AspNetUsers_PatientId",
                        column: x => x.PatientId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Appointments_Services_ServiceId",
                        column: x => x.ServiceId,
                        principalTable: "Services",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    ProviderKey = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Logs",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ActivityId = table.Column<int>(type: "integer", nullable: false),
                    TableName = table.Column<string>(type: "text", nullable: true),
                    RowId = table.Column<int>(type: "integer", nullable: true),
                    Email = table.Column<string>(type: "text", nullable: true),
                    IPAddress = table.Column<string>(type: "text", nullable: false),
                    HostName = table.Column<string>(type: "text", nullable: false),
                    WebBrowser = table.Column<string>(type: "text", nullable: false),
                    ActiveUrl = table.Column<string>(type: "text", nullable: false),
                    ReferrerUrl = table.Column<string>(type: "text", nullable: false),
                    Controller = table.Column<string>(type: "text", nullable: false),
                    ActionMethod = table.Column<string>(type: "text", nullable: false),
                    ExceptionType = table.Column<string>(type: "text", nullable: true),
                    ExceptionMessage = table.Column<string>(type: "text", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Logs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Logs_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    Message = table.Column<string>(type: "text", nullable: false),
                    Read = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Orders",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    PatientId = table.Column<int>(type: "integer", nullable: false),
                    TransactionId = table.Column<string>(type: "text", nullable: true),
                    FullName = table.Column<string>(type: "text", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    PaymentMethod = table.Column<string>(type: "text", nullable: true),
                    DeliveryMethod = table.Column<string>(type: "text", nullable: true),
                    Note = table.Column<string>(type: "text", nullable: true),
                    TotalAmount = table.Column<decimal>(type: "numeric", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    Date = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Orders", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Orders_AspNetUsers_PatientId",
                        column: x => x.PatientId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reports",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    PublisherId = table.Column<int>(type: "integer", nullable: true),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    Data = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reports", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reports_AspNetUsers_PublisherId",
                        column: x => x.PublisherId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    PatientId = table.Column<int>(type: "integer", nullable: false),
                    AppointmentId = table.Column<int>(type: "integer", nullable: true),
                    EmployeeId = table.Column<int>(type: "integer", nullable: false),
                    Rating = table.Column<int>(type: "integer", nullable: false),
                    Comment = table.Column<string>(type: "text", nullable: true),
                    ReviewDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reviews_Appointments_AppointmentId",
                        column: x => x.AppointmentId,
                        principalTable: "Appointments",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Reviews_AspNetUsers_EmployeeId",
                        column: x => x.EmployeeId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reviews_AspNetUsers_PatientId",
                        column: x => x.PatientId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "OrderItems",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    OrderId = table.Column<int>(type: "integer", nullable: false),
                    ProductId = table.Column<int>(type: "integer", nullable: false),
                    Quantity = table.Column<int>(type: "integer", nullable: false),
                    UnitPrice = table.Column<decimal>(type: "numeric", nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrderItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OrderItems_Orders_OrderId",
                        column: x => x.OrderId,
                        principalTable: "Orders",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OrderItems_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Payments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IsPaid = table.Column<bool>(type: "boolean", nullable: false),
                    DateFrom = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateTo = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    PatientId = table.Column<int>(type: "integer", nullable: false),
                    OrderId = table.Column<int>(type: "integer", nullable: false),
                    Price = table.Column<decimal>(type: "numeric", nullable: false),
                    Discount = table.Column<decimal>(type: "numeric", nullable: true),
                    Note = table.Column<string>(type: "text", nullable: true),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    TransactionId = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Payments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Payments_AspNetUsers_PatientId",
                        column: x => x.PatientId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Payments_Orders_OrderId",
                        column: x => x.OrderId,
                        principalTable: "Orders",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "DateCreated", "DateUpdated", "IsDeleted", "Name", "NormalizedName", "RoleLevel" },
                values: new object[,]
                {
                    { 1, "dd702551-5903-4e42-b2de-8ef67c096b18", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Administrator", "ADMINISTRATOR", 1 },
                    { 2, "c703c999-ab91-4b5f-b8de-bc1d0cf42566", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Employee", "EMPLOYEE", 2 },
                    { 3, "36fb02fa-f9df-43aa-9536-0e561e5f18aa", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Patient", "PATIENT", 3 }
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "Address", "BirthDate", "ConcurrencyStamp", "CountryId", "DateCreated", "DateUpdated", "Description", "Email", "EmailConfirmed", "FirstName", "Gender", "IsActive", "IsDeleted", "IsFirstLogin", "LastName", "LicenseNumber", "LockoutEnabled", "LockoutEnd", "MedicalRecordId", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "ProfilePhoto", "ProfilePhotoThumbnail", "SecurityStamp", "TwoFactorEnabled", "UserName", "VerificationSent", "WorkingHours", "YearsOfExperience" },
                values: new object[,]
                {
                    { 1, 0, "Mostar b.b", new DateTime(1999, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "89506cb8-9fdd-462d-8063-acb10405c1ae", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "site.admin@crystal_skin.com", true, "Site", 1, true, false, false, "Admin", null, false, null, null, "SITE.ADMIN@CRYSTAL_SKIN.COM", "SITE.ADMIN", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "site.admin", false, null, null },
                    { 2, 0, "Mostar b.b", new DateTime(2005, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "fe6a7a20-292a-4f53-a4b9-48a1aa7f6672", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "doctor@mail.com", true, "Doctor", 1, true, false, false, "1", null, false, null, null, "DOCTOR@MAIL.COM", "DOCTOR", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "doctor", false, null, null }
                });

            migrationBuilder.InsertData(
                table: "Countries",
                columns: new[] { "Id", "Abrv", "DateCreated", "DateUpdated", "IsActive", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "BiH", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Bosna i Hercegovina" },
                    { 2, "HR", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Hrvatska" },
                    { 3, "SRB", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Srbija" },
                    { 4, "CG", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Crna Gora" },
                    { 5, "MKD", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Makedonija" }
                });

            migrationBuilder.InsertData(
                table: "MedicalRecords",
                columns: new[] { "Id", "Allergies", "BloodType", "DateCreated", "DateUpdated", "Diagnoses", "Height", "IsDeleted", "LastUpdatedByEmployeeId", "Notes", "Treatments", "Weight" },
                values: new object[,]
                {
                    { 1, "Nema poznatih alergija", "A+", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Akne vulgaris", 178.0m, false, null, "Pacijentu savjetovana higijena lica i izbjegavanje masne hrane.", "Lokalna terapija benzoil peroksidom, antibiotska krema", 74.0m },
                    { 2, "Alergija na kortikosteroide", "B-", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Psorijaza", 165.0m, false, null, "Praćenje kroz naredna tri mjeseca, izbjegavati stres.", "Topikalni kortikosteroidi (niskog intenziteta), UVB terapija", 68.5m },
                    { 3, "Prašina, nikal", "AB+", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Atopijski dermatitis", 172.5m, false, null, "Preporučena upotreba blagih sapuna i izbjegavanje iritansa.", "Hidratantne kreme, antihistaminici", 61.0m },
                    { 4, "Lateks", "O+", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Kontaktni dermatitis", 180.0m, false, null, "Kožne promjene prisutne na rukama, praćenje reakcije na terapiju.", "Izbjegavanje alergena, kortikosteroidna mast", 85.0m },
                    { 5, "Nema", "A-", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "Seboroični dermatitis", 169.5m, false, null, "Promjene izražene na vlasištu i iza ušiju.", "Šampon s ketokonazolom, krema sa cinkom", 70.0m }
                });

            migrationBuilder.InsertData(
                table: "ProductCategories",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Njega lica" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Njega tijela" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Dodaci prehrani" }
                });

            migrationBuilder.InsertData(
                table: "Services",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "Duration", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeSpan(0, 0, 10, 0, 0), false, "Konsultacija kože" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeSpan(0, 0, 20, 0, 0), false, "Tretman akni" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeSpan(0, 0, 30, 0, 0), false, "Uklanjanje mladeža" },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeSpan(0, 0, 35, 0, 0), false, "Laser terapija" },
                    { 5, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeSpan(0, 0, 40, 0, 0), false, "Hemijski piling" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 1 },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 2 }
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "Address", "BirthDate", "ConcurrencyStamp", "CountryId", "DateCreated", "DateUpdated", "Description", "Email", "EmailConfirmed", "FirstName", "Gender", "IsActive", "IsDeleted", "IsFirstLogin", "LastName", "LicenseNumber", "LockoutEnabled", "LockoutEnd", "MedicalRecordId", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "ProfilePhoto", "ProfilePhotoThumbnail", "SecurityStamp", "TwoFactorEnabled", "UserName", "VerificationSent", "WorkingHours", "YearsOfExperience" },
                values: new object[,]
                {
                    { 3, 0, "Mostar b.b", new DateTime(1999, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "f50e9a17-860b-4607-b1ef-5a79b7660e72", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "patient1@mail.com", true, "Patient", 1, true, false, false, "1", null, false, null, 1, "PATIENT1@MAIL.COM", "patient1", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "patient1", false, null, null },
                    { 4, 0, "Mostar b.b", new DateTime(1979, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "4ecbc25b-b156-4ce1-ab8e-1e6033a95bb6", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "patient2@mail.com", true, "Patient", 2, true, false, false, "2", null, false, null, 2, "PATIENT2@MAIL.COM", "PATIENT2", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "patient2", false, null, null },
                    { 5, 0, "Mostar b.b", new DateTime(1989, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "73a21f7d-f4b0-40cd-8022-41de684de02a", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "patient3@mail.com", true, "Patient", 1, true, false, false, "3", null, false, null, 3, "Patient3@MAIL.COM", "PATIENT3", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "patient3", false, null, null }
                });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "Abrv", "CountryId", "DateCreated", "DateUpdated", "IsActive", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "MO", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Mostar" },
                    { 2, "SA", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Sarajevo" },
                    { 3, "JC", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Jajce" },
                    { 4, "TZ", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Tuzla" },
                    { 5, "ZG", 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Zagreb" }
                });

            migrationBuilder.InsertData(
                table: "Products",
                columns: new[] { "Id", "Barcode", "DateCreated", "DateUpdated", "Description", "ImageUrl", "Ingredients", "IsDeleted", "IsEnable", "Manufacturer", "Name", "Price", "ProductCategoryId", "Stock" },
                values: new object[,]
                {
                    { 1, "1234567890123", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Krema za dubinsku hidrataciju suhe kože.", "https://logotyp.us/file/dm.svg", "Aqua, Glycerin, Aloe Vera", false, true, "Dermaline", "Hidratantna krema", 19.99m, 1, 100 },
                    { 2, "1112223330000", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Specijalizovana krema za tretman akni i mitesera.", "https://logotyp.us/file/dm.svg", "Salicylic Acid, Tea Tree Oil", false, true, "AcneFix", "Krema za akne", 22.50m, 1, 80 },
                    { 3, "4567891234567", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Regenerišuća noćna krema protiv bora.", "https://logotyp.us/file/dm.svg", "Retinol, Hyaluronic Acid", false, true, "YouthSkin", "Noćna anti-age krema", 29.90m, 1, 60 },
                    { 4, "8887776665554", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Micelarna voda za uklanjanje šminke i nečistoća.", "https://logotyp.us/file/dm.svg", "Aqua, Micelles, Chamomile Extract", false, true, "CleanFace", "Micelarna voda", 11.99m, 1, 120 },
                    { 5, "9090901234567", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Prirodna maska sa zelenom glinom za čišćenje pora.", "https://logotyp.us/file/dm.svg", "Green Clay, Aloe Vera", false, true, "NatureBeauty", "Maska za lice - glina", 13.75m, 1, 95 },
                    { 6, "9876543210987", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Osvježavajući gel za tuširanje sa citrusima.", "https://logotyp.us/file/dm.svg", "Aqua, Sodium Laureth Sulfate, Citrus Extract", false, true, "BodyFresh", "Gel za tuširanje", 9.49m, 2, 200 },
                    { 7, "3332221114448", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Hidratantni losion za svakodnevnu njegu kože tijela.", "https://logotyp.us/file/dm.svg", "Shea Butter, Vitamin E", false, true, "SoftSkin", "Losion za tijelo", 12.30m, 2, 150 },
                    { 8, "5656565656565", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Bogata krema za njegu i zaštitu ruku.", "https://logotyp.us/file/dm.svg", "Glycerin, Panthenol", false, true, "CareHands", "Krema za ruke", 5.99m, 2, 300 },
                    { 9, "7778889991112", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Prirodno ulje za relaksirajuću masažu.", "https://logotyp.us/file/dm.svg", "Lavender Oil, Almond Oil", false, true, "RelaxTime", "Ulje za masažu", 18.00m, 2, 70 },
                    { 10, "2223334445556", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Piling sa morskom soli za glatku kožu.", "https://logotyp.us/file/dm.svg", "Sea Salt, Coconut Oil", false, true, "SeaBeauty", "Piling za tijelo", 15.90m, 2, 85 },
                    { 11, "1112223334445", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Kompleks vitamina i minerala za svakodnevnu upotrebu.", "https://logotyp.us/file/dm.svg", "Vitamin A, C, D, E, Zinc, Iron", false, true, "NutriLife", "Multivitamin kapsule", 14.99m, 3, 150 },
                    { 12, "0001112223334", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Kapsule ribljeg ulja bogate omega-3 masnim kiselinama.", "https://logotyp.us/file/dm.svg", "Fish Oil, EPA, DHA", false, true, "HeartWell", "Omega 3 kapsule", 17.49m, 3, 130 },
                    { 13, "4445556667778", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Tablete vitamina C za jačanje imuniteta.", "https://logotyp.us/file/dm.svgg", "Vitamin C, Citrus Bioflavonoids", false, true, "C-Boost", "Vitamin C tablete", 6.99m, 3, 180 },
                    { 14, "5556667778889", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Probiotici za zdravlje crijeva.", "https://logotyp.us/file/dm.svg", "Lactobacillus, Bifidobacterium", false, true, "GutHealth", "Probiotik kapsule", 16.75m, 3, 110 },
                    { 15, "6667778889990", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Tablete za podršku nervnom sistemu i mišićima.", "https://logotyp.us/file/dm.svg", "Magnesium Citrate", false, true, "VitalPower", "Magnezijum tablete", 8.20m, 3, 140 }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 3 },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 4 },
                    { 5, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 5 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_EmployeeId",
                table: "Appointments",
                column: "EmployeeId");

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_PatientId",
                table: "Appointments",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Appointments_ServiceId",
                table: "Appointments",
                column: "ServiceId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_UserId",
                table: "AspNetUserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUsers_CountryId",
                table: "AspNetUsers",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUsers_MedicalRecordId",
                table: "AspNetUsers",
                column: "MedicalRecordId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CountryId",
                table: "Cities",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_Logs_UserId",
                table: "Logs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_OrderId",
                table: "OrderItems",
                column: "OrderId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_ProductId",
                table: "OrderItems",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_PatientId",
                table: "Orders",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_OrderId",
                table: "Payments",
                column: "OrderId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_PatientId",
                table: "Payments",
                column: "PatientId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_ProductCategoryId",
                table: "Products",
                column: "ProductCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Reports_PublisherId",
                table: "Reports",
                column: "PublisherId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_AppointmentId",
                table: "Reviews",
                column: "AppointmentId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_EmployeeId",
                table: "Reviews",
                column: "EmployeeId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_PatientId",
                table: "Reviews",
                column: "PatientId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Logs");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "OrderItems");

            migrationBuilder.DropTable(
                name: "Payments");

            migrationBuilder.DropTable(
                name: "Reports");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropTable(
                name: "Orders");

            migrationBuilder.DropTable(
                name: "Appointments");

            migrationBuilder.DropTable(
                name: "ProductCategories");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "Services");

            migrationBuilder.DropTable(
                name: "Countries");

            migrationBuilder.DropTable(
                name: "MedicalRecords");
        }
    }
}
