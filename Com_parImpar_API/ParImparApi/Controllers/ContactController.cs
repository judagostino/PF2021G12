using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;
using ParImparApi.NLog;
using ParImparApi.Services;

namespace ParImparApi.Controllers
{
    [ApiController]
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    public class ContactController : ControllerBase
    {
        private readonly AuthService _authService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public ContactController(AuthService authService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _authService = authService ?? throw new ArgumentNullException(nameof(authService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [Register]
        // POST: api/v1/Contact/Register
        [HttpPost("Register")]
        [AllowAnonymous]
        public async Task<IActionResult> CredentialsLogin([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(registerUser.Email) || string.IsNullOrWhiteSpace(registerUser.ConfirmEmail))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.EmailRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.UserName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.UserNameRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.FistName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.FirstNameRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.LastName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.LastNameRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.Password) || string.IsNullOrWhiteSpace(registerUser.ConfirmPassword))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.PasswordRequiredField, registerUser));
                }

                ApiResponse response = await _authService.RegistrerUser(registerUser);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.DistintEmail:
                    case CustomStatusCodes.EmailExist:
                    case CustomStatusCodes.EmailRequiredField:
                    case CustomStatusCodes.UserNameRequiredField:
                    case CustomStatusCodes.FirstNameRequiredField:
                    case CustomStatusCodes.LastNameRequiredField:
                    case CustomStatusCodes.PasswordRequiredField:
                    case CustomStatusCodes.DistintPassword:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [Update]
        // POST: api/v1/Auth/Update
        [HttpPost("Update")]
        [Authorize("RefreshAuth")]
        public async Task<IActionResult> RegenerateToken([FromBody] ChangeTokenRequestDTO changeToken)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(changeToken.Access))
                {
                    return Unauthorized();
                }


                ApiResponse response = await _authService.Update(changeToken);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }
                    case CustomStatusCodes.UserAgentInvalid:
                    case CustomStatusCodes.UnauthorizedIp:
                    case CustomStatusCodes.NotFound:
                        {
                            return StatusCode(StatusCodes.Status401Unauthorized, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
                        }
                }

            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, null));
            }
        }
        #endregion
    }
}
