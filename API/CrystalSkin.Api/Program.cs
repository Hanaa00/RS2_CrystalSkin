using CrystalSkin.Api;
using CrystalSkin.Services.Hubs;
using CrystalSkin.Services.Services.RecommendationService;
using QuestPDF.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

var envConnectionString = Environment.GetEnvironmentVariable("ConnectionStrings_Main");

var connectionString = !string.IsNullOrWhiteSpace(envConnectionString)
    ? envConnectionString
    : builder.Configuration.GetConnectionString("Main");

builder.Services.AddServices();
builder.Services.AddMapper();
builder.Services.AddLocalization();
builder.Services.AddValidators();
builder.Services.AddSwaggerViewer();
builder.Services.AddDatabase(connectionString);
builder.Services.AddOther();
builder.Services.AddUserIdentity(builder.Configuration);
builder.Services.AddSession();
builder.Services.AddHttpContextAccessor();
builder.Services.AddSignalR();
builder.Services.AddControllers();

builder.Services.AddCors(options =>
{
    options.AddPolicy("MyCorsPolicy", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

#region App

var app = builder.Build();

app.UseCors("MyCorsPolicy");
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
});
app.UseDeveloperExceptionPage();

app.UseHttpsRedirection();
app.UseSession();
app.UseAuthentication();
app.UseStaticFiles();

app.UseAuthorization();

app.MapControllers();
app.MapHub<NotificationHub>("/hubs/notifications");

QuestPDF.Settings.License = LicenseType.Community;

using var scope = app.Services.CreateScope();

var ctx = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
ctx.Initialize();

var recommendationService = scope.ServiceProvider.GetRequiredService<IRecommendationService>();
recommendationService.TrainModel();

await app.RunAsync();
#endregion
