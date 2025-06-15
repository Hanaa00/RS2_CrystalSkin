using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace CrystalSkin.Services.Migrations
{
    /// <inheritdoc />
    public partial class ordersseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Orders",
                columns: new[] { "Id", "Address", "Date", "DateCreated", "DateUpdated", "DeliveryMethod", "FullName", "IsDeleted", "Note", "PatientId", "PaymentMethod", "PhoneNumber", "Status", "TotalAmount", "TransactionId" },
                values: new object[,]
                {
                    { 1, "Adresa 3", new DateTime(2025, 3, 6, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(6765), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 3", false, "Napomena za narudžbu 1", 3, "kartica", "061-100030", 2, 143m, "i_0001" },
                    { 2, "Adresa 3", new DateTime(2025, 4, 13, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(6890), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 3", false, "Napomena za narudžbu 2", 3, "kartica", "061-100031", 2, 126m, "i_0002" },
                    { 3, "Adresa 3", new DateTime(2025, 4, 27, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7039), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 3", false, "Napomena za narudžbu 3", 3, "kartica", "061-100032", 2, 326m, "i_0003" },
                    { 4, "Adresa 4", new DateTime(2025, 4, 29, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7060), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 4", false, "Napomena za narudžbu 4", 4, "kartica", "061-100040", 2, 67m, "i_0004" },
                    { 5, "Adresa 4", new DateTime(2025, 4, 12, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7077), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 4", false, "Napomena za narudžbu 5", 4, "kartica", "061-100041", 2, 132m, "i_0005" },
                    { 6, "Adresa 4", new DateTime(2025, 5, 2, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7093), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 4", false, "Napomena za narudžbu 6", 4, "kartica", "061-100042", 2, 75m, "i_0006" },
                    { 7, "Adresa 5", new DateTime(2025, 4, 18, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7108), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 5", false, "Napomena za narudžbu 7", 5, "kartica", "061-100050", 2, 148m, "i_0007" },
                    { 8, "Adresa 5", new DateTime(2025, 3, 13, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7123), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 5", false, "Napomena za narudžbu 8", 5, "kartica", "061-100051", 2, 247m, "i_0008" },
                    { 9, "Adresa 5", new DateTime(2025, 3, 11, 21, 12, 7, 386, DateTimeKind.Utc).AddTicks(7169), new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "dostavaa", "Pacijent 5", false, "Napomena za narudžbu 9", 5, "kartica", "061-100052", 2, 126m, "i_0009" }
                });

            migrationBuilder.InsertData(
                table: "OrderItems",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "Notes", "OrderId", "ProductId", "Quantity", "UnitPrice" },
                values: new object[,]
                {
                    { 1, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 1, 10, 2, 59m },
                    { 2, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 1, 3, 1, 25m },
                    { 3, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 2, 13, 2, 55m },
                    { 4, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 2, 7, 1, 16m },
                    { 5, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 3, 10, 2, 33m },
                    { 6, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 3, 12, 2, 22m },
                    { 7, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 3, 15, 2, 53m },
                    { 8, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 3, 5, 2, 55m },
                    { 9, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 4, 1, 1, 29m },
                    { 10, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 4, 15, 1, 38m },
                    { 11, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 5, 5, 2, 58m },
                    { 12, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 5, 9, 1, 16m },
                    { 13, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 6, 7, 1, 19m },
                    { 14, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 6, 15, 1, 21m },
                    { 15, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 6, 10, 1, 35m },
                    { 16, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 7, 9, 2, 23m },
                    { 17, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 7, 3, 2, 51m },
                    { 18, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 8, 2, 2, 55m },
                    { 19, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 8, 6, 2, 55m },
                    { 20, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 8, 10, 1, 27m },
                    { 21, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 9, 1, 1, 44m },
                    { 22, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 9, 14, 2, 25m },
                    { 23, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, null, 9, 2, 1, 32m }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "OrderItems",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Orders",
                keyColumn: "Id",
                keyValue: 9);
        }
    }
}
