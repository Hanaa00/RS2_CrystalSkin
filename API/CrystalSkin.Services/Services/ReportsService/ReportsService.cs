using Microsoft.EntityFrameworkCore;
using QuestPDF.Fluent;
using QuestPDF.Helpers;

namespace CrystalSkin.Services;

public class ReportsService : IReportsService
{
    private readonly DatabaseContext _databaseContext;

    public ReportsService(DatabaseContext databaseContext)
    {
        _databaseContext = databaseContext;
    }

    public async Task<byte[]> GeneratePatientsReport(UsersSearchObject searchObject)
    {
        var data = await _databaseContext.Users
            .Include(x => x.MedicalRecord)
            .Where(x => (searchObject.SearchFilter == null
                || EF.Functions.ILike(x.UserName!, $"%{searchObject.SearchFilter}%", "\\")
                || EF.Functions.ILike(x.Email!, $"%{searchObject.SearchFilter}%", "\\"))
                && x.UserRoles.Any(x => x.RoleId == (int)RoleLevel.Patient)
                && x.IsActive
                && !x.IsDeleted)
            .Select(x => new PatientReportModel
            {
                FirstName = x.FirstName!,
                LastName = x.LastName!,
                Email = x.Email!,
                Height = x.MedicalRecord!.Height,
                Weight = x.MedicalRecord.Weight
            })
            .ToListAsync();


        return Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(30);
                page.DefaultTextStyle(x => x.FontSize(12));

                page.Header().Background(Colors.Cyan.Darken2).Padding(10).Row(row =>
                {
                    row.RelativeColumn().AlignLeft().Text($"Izvještaj o pacijentima")
                        .SemiBold().FontSize(20).FontColor(Colors.White);
                    row.ConstantColumn(150).AlignRight().Text($"Status : aktivni")
                        .FontColor(Colors.White);
                });

                page.Content().PaddingVertical(15).Column(col =>
                {
                    col.Spacing(10);

                    col.Item().Table(table =>
                    {
                        table.ColumnsDefinition(columns =>
                        {
                            columns.RelativeColumn(1);
                            columns.RelativeColumn(1);
                            columns.RelativeColumn(2);
                            columns.RelativeColumn(1);
                            columns.RelativeColumn(1);
                        });

                        table.Header(header =>
                        {
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .Text("Ime").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .Text("Prezime").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .Text("Email").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .AlignRight().Text("Visina (cm)").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .AlignRight().Text("Težina (kg)").SemiBold();
                        });

                        var useAlternate = false;
                        foreach (var item in data)
                        {
                            var background = useAlternate ? Colors.Grey.Lighten5 : Colors.White;
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.FirstName);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.LastName);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.Email);
                            table.Cell().Background(background).Padding(5)
                                  .AlignRight().Text(item.Height.ToString("0.00"));
                            table.Cell().Background(background).Padding(5)
                                  .AlignRight().Text(item.Weight.ToString("0.00"));

                            useAlternate = !useAlternate;
                        }
                    });
                });

                page.Footer().AlignCenter().PaddingTop(10).Text(x =>
                {
                    x.Span("Stranica ");
                    x.CurrentPageNumber();
                    x.Span(" od ");
                    x.TotalPages();
                });
            });
        })
        .GeneratePdf();
    }

    public async Task<byte[]> GenerateOrdersReport(OrderSearchObject searchObject)
    {
        var data = await _databaseContext.Orders
            .Where(o =>
            (
                string.IsNullOrEmpty(searchObject.SearchFilter)
                || o.Id.ToString().Contains(searchObject.SearchFilter.ToLower())
                || (o.Patient.FirstName + " " + o.Patient.LastName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                || (o.Patient.LastName + " " + o.Patient.FirstName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                || (!string.IsNullOrEmpty(o.TransactionId) && o.TransactionId.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                || o.Items.Any(i => i.Product.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())))
                && (searchObject.Status == null || searchObject.Status == o.Status)
                && !o.IsDeleted)
            .Select(x => new OrderReportModel
            {
                Address = x.Address,
                TotalAmount = x.TotalAmount,
                Date = x.Date,
                DeliveryMethod = x.DeliveryMethod,
                FullName = x.FullName,
                PaymentMethod = x.PaymentMethod,
                PhoneNumber = x.PhoneNumber,
                Status = x.Status.ToString(),
                TransactionId = x.TransactionId
            })
            .OrderByDescending(o => o.Date)
            .ToListAsync();

        return Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(30);
                page.DefaultTextStyle(x => x.FontSize(12));

                page.Header().Background(Colors.Cyan.Darken2).Padding(10).Row(row =>
                {
                    row.RelativeColumn().AlignLeft().Text($"Izvještaj o naružbama")
                        .SemiBold().FontSize(20).FontColor(Colors.White);
                });

                page.Content().PaddingVertical(15).Column(col =>
                {
                    col.Spacing(10);

                    col.Item().Table(table =>
                    {
                        table.ColumnsDefinition(columns =>
                        {
                            columns.RelativeColumn(2); // Transaction
                            columns.RelativeColumn(2); // Fullname
                            columns.RelativeColumn(2); // Phone number
                            columns.RelativeColumn(1); // Address
                            columns.RelativeColumn(1); // Payment method
                            columns.RelativeColumn(1); // Status
                            columns.RelativeColumn(2); // Date
                            columns.RelativeColumn(1); // Total amount
                        });

                        table.Header(header =>
                        {
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .Text("Transakcija").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                 .Text("Pacijent").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .Text("Broj telefona").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .Text("Adresa").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .AlignRight().Text("Metoda plaćanja").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .AlignRight().Text("Status").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .AlignRight().Text("Datum").SemiBold();
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                  .AlignRight().Text("Iznos").SemiBold();
                        });

                        var useAlternate = false;
                        foreach (var item in data)
                        {
                            var background = useAlternate ? Colors.Grey.Lighten5 : Colors.White;
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.TransactionId);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.FullName);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.PhoneNumber);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.Address);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.PaymentMethod);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.Status);
                            table.Cell().Background(background).Padding(5)
                                  .Text(item.Date?.ToString("dd.MM.yyyy"));
                            table.Cell().Background(background).Padding(5)
                                  .AlignRight().Text(item.TotalAmount.ToString("0.00"));

                            useAlternate = !useAlternate;
                        }
                    });
                });

                // FOOTER STRANICA
                page.Footer().AlignCenter().PaddingTop(10).Text(x =>
                {
                    x.Span("Stranica ");
                    x.CurrentPageNumber();
                    x.Span(" od ");
                    x.TotalPages();
                });
            });
        })
        .GeneratePdf();
    }
}
