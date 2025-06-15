namespace CrystalSkin.Shared;

public class EmailMessages
{
    public const string ConfirmationEmailSubject = "Crystal Skin Dermatology Center | Aktivacija korisničkog naloga";

    public static string GeneratePasswordEmail(string name, string password)
    {
        string body =
            $"<div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto;color:#333;'>" +
            $"  <div style='background-color:#f8f9fa;padding:20px;text-align:center;border-bottom:3px solid #4a90e2;'>" +
            $"    <h2 style='color:#4a90e2;margin:0;'>Crystal Skin Dermatology Center</h2>" +
            $"  </div>" +
            $"  <div style='padding:30px;'>" +
            $"    <p style='font-size:16px;'>Poštovani/a {name},</p>" +
            $"    <p style='font-size:16px;'>Dobrodošli u Crystal Skin - digitalni sistem našeg dermatološkog centra.</p>" +
            $"    <p style='font-size:16px;'>Vaš korisnički nalog je uspešno kreiran.</p>" +
            $"    " +
            $"    <div style='background-color:#f8f9fa;padding:15px;border-radius:5px;margin:20px 0;text-align:center;'>" +
            $"      <p style='margin:5px 0;font-size:14px;'>Privremena lozinka za pristup:</p>" +
            $"      <p style='margin:5px 0;font-size:18px;font-weight:bold;letter-spacing:1px;'>{password}</p>" +
            $"      <p style='margin:5px 0;font-size:12px;color:#666;'>Molimo Vas da promijenite lozinku pri prvoj prijavi.</p>" +
            $"    </div>" +
            $"    " +
            $"    <p style='font-size:16px;'>Ukoliko imate bilo kakvih pitanja, naš tim je vam stoji na raspolaganju.</p>" +
            $"    <p style='font-size:16px;'>Srdačno,<br/>Tim Crystal Skin Dermatology Centra</p>" +
            $"  </div>" +
            $"  <div style='background-color:#f8f9fa;padding:15px;text-align:center;font-size:12px;color:#666;border-top:1px solid #ddd;'>" +
            $"    <p>© {DateTime.Now.Year} Crystal Skin Dermatology Center. Sva prava zadržana.</p>" +
            $"  </div>" +
            $"</div>";

        return EmailWrapper.WrapBody(body);
    }
}
