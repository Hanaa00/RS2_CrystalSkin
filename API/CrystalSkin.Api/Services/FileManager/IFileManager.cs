namespace CrystalSkin.Api;
public interface IFileManager
{
    Task<string> UploadFileAsync(IFormFile file);
    void DeleteFile(string? filePath);
}