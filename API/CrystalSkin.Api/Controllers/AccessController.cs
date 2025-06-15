using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using CrystalSkin.Core;
using CrystalSkin.Core.Models;
using CrystalSkin.Services;
using CrystalSkin.Shared;

namespace CrystalSkin.Api.Controllers
{
    [ApiController]
    [Route("/[controller]/[action]")]
    public class AccessController : BaseController
    {
        private readonly IAccessManager _accessManager;
        private readonly IUsersService _usersService;
        private readonly IMapper _mapper;
        public AccessController(
            IAccessManager accessManager,
            IUsersService usersService,
            IMapper mapper,
            ILogger<AccessController> logger,
            IActivityLogsService activityLogs) : base(logger, activityLogs)
        {
            _accessManager = accessManager;
            _usersService = usersService;
            _mapper = mapper;
        }

        [HttpPost]
        public async Task<IActionResult> SignIn(AccessSignInModel model, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(model.UserName) || string.IsNullOrWhiteSpace(model.Password))
                return BadRequest("Model is not valid");
            try
            {

                var loginInformation = await _accessManager.SignInAsync(model.UserName, model.Password);

                return Ok(loginInformation);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing in user");
                return BadRequest(e.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Registration([FromBody] RegistrationModel model)
        {
            try
            {
                return Ok(await _usersService.AddAsync(_mapper.Map<UserUpsertModel>(model)));
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when registration user");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _usersService.GetType().ToString(), e, null, model.UserName);
                return BadRequest(e.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> ChangePassword(ChangePasswordModel model)
        {
            try
            {
                var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");
                if (userId == 0)
                {
                    throw new Exception("UserIsNotAuthenticated");
                }
                var result = await _accessManager.ChangePassword(userId, model.CurrentPassword, model.NewPassword);
                return Ok(result);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when changing password");
                return BadRequest(e.Message);
            }
        }

        private IActionResult ValidationResult(List<CrystalSkin.Core.ValidationError> errors)
        {
            var dictionary = new Dictionary<string, List<string>>();

            foreach (var error in errors)
            {
                if (!dictionary.ContainsKey(error.PropertyName))
                    dictionary.Add(error.PropertyName, new List<string>());

                dictionary[error.PropertyName].Add(error.ErrorCode);
            }

            return BadRequest(new
            {
                Errors = dictionary.Select(i => new
                {
                    PropertyName = i.Key,
                    ErrorCodes = i.Value
                })
            });
        }
    }
}
