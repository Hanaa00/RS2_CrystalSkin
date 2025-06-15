using CrystalSkin.Services.Services.RecommendationService;

namespace CrystalSkin.Api.Controllers;

[ApiController]
[Route("/[controller]")]
public class RecommendationsController : ControllerBase
{
    private readonly IRecommendationService _recommendationService;

    public RecommendationsController(IRecommendationService recommendationService)
    {
        _recommendationService = recommendationService;
    }

    [HttpGet("{userId}")]
    public ActionResult<List<int>> Get(int userId, int topN = 5)
    {
        var recommendations = _recommendationService.GetTopRecommendationsForUser(userId, topN);
        return Ok(recommendations);
    }
}
