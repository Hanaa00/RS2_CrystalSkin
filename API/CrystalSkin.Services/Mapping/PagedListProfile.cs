namespace CrystalSkin.Services.Mapping;

public class PagedListProfile : BaseProfile
{
    public PagedListProfile()
    {
        CreateMap(typeof(PagedList<>), typeof(PagedList<>));
    }
}
