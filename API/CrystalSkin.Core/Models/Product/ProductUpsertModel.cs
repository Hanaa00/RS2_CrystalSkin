using Microsoft.AspNetCore.Http;

namespace CrystalSkin.Core.Models;

public class ProductUpsertModel : BaseUpsertModel
{
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public decimal Price { get; set; }
    public int Stock { get; set; }
    public string? ImageUrl { get; set; } = "";
    public bool IsEnable { get; set; } = true;
    public string? Manufacturer { get; set; }
    public string? Barcode { get; set; }
    public string? Ingredients { get; set; }
    public int ProductCategoryId { get; set; }
    public IFormFile? ImageFile { get; set; } = default!;
}
