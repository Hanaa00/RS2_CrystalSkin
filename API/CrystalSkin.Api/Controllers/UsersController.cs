using CrystalSkin.Core.Models;

namespace CrystalSkin.Api.Controllers;

//[Authorize(AuthenticationSchemes = "Bearer")]
public class UsersController : BaseCrudController<UserModel, UserUpsertModel, UsersSearchObject, IUsersService>
{
    private readonly IFileManager _fileManager;
    public UsersController(
        IUsersService service,
        ILogger<UsersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper,
        IFileManager fileManager) : base(service, logger, activityLogs)
    {
        _fileManager = fileManager;
    }

    [HttpPost]
    public override async Task<IActionResult> Post([FromForm] UserUpsertModel model, CancellationToken cancellationToken = default)
    {
        try
        {
            model.ProfilePhotoFile = GetFormFile();

            if (model.ProfilePhotoFile != null)
            {
                model.ProfilePhoto = await _fileManager.UploadFileAsync(model.ProfilePhotoFile);
            }

            var result = await Service.AddAsync(model, cancellationToken);
            return Ok(result);

        }
        catch (ValidationException e)
        {
            Logger.LogError(e, "Problem when posting resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { model.Id });
            return ValidationResult(e.Errors);
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Problem when posting resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { model.Id });
            return BadRequest();
        }
    }

    [HttpPut]
    public override async Task<IActionResult> Put([FromForm] UserUpsertModel upsertModel, CancellationToken cancellationToken = default)
    {
        try
        {
            upsertModel.ProfilePhotoFile = GetFormFile();

            if (upsertModel.ProfilePhotoFile != null)
            {
                upsertModel.ProfilePhoto = await _fileManager.UploadFileAsync(upsertModel.ProfilePhotoFile);
            }

            var dto = await Service.UpdateAsync(upsertModel, cancellationToken);
            return Ok(dto);
        }
        catch (ValidationException e)
        {
            Logger.LogError(e, "Problem when updating resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
            return ValidationResult(e.Errors);
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Problem when updating resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
            return BadRequest();
        }
    }
}
