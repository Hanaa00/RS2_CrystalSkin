using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace CrystalSkin.Services.Migrations
{
    /// <inheritdoc />
    public partial class notificationsseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "Message", "Read", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 5, 20, 9, 0, 0, 0, DateTimeKind.Unspecified), null, false, "Dobrodošli u dermatološki centar! Vaš profil je aktiviran.", false, 3 },
                    { 2, new DateTime(2025, 5, 22, 14, 30, 0, 0, DateTimeKind.Unspecified), null, false, "Termin pregleda potvrđen za 03.06.2025. u 11:00.", true, 3 },
                    { 3, new DateTime(2025, 5, 25, 10, 15, 0, 0, DateTimeKind.Unspecified), null, false, "Vaši rezultati testiranja kože su spremni za preuzimanje.", false, 3 },
                    { 4, new DateTime(2025, 5, 21, 8, 45, 0, 0, DateTimeKind.Unspecified), null, false, "Podsjetnik: tretman odstranjivanja madeža 05.06.2025. u 12:00.", false, 4 },
                    { 5, new DateTime(2025, 5, 23, 9, 30, 0, 0, DateTimeKind.Unspecified), null, false, "Upute za pripremu kože prije tretmana su poslane na vašu e-poštu.", true, 4 },
                    { 6, new DateTime(2025, 5, 26, 16, 0, 0, 0, DateTimeKind.Unspecified), null, false, "Novi savjet za njegu kože dostupan je na vašem profilu.", false, 4 },
                    { 7, new DateTime(2025, 5, 19, 13, 20, 0, 0, DateTimeKind.Unspecified), null, false, "Vaš zahtjev za promjenu termina je odobren.", true, 5 },
                    { 8, new DateTime(2025, 5, 27, 7, 0, 0, 0, DateTimeKind.Unspecified), null, false, "Podsjetnik: savjetovanje s dermatologom sutra u 10:00.", false, 5 },
                    { 9, new DateTime(2025, 5, 28, 12, 0, 0, 0, DateTimeKind.Unspecified), null, false, "Ponuda: 10% popusta na paket tretmana lica.", false, 5 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Notifications",
                keyColumn: "Id",
                keyValue: 9);
        }
    }
}
