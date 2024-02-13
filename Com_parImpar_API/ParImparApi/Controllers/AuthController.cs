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
    public class AuthController : ControllerBase
    {
        private readonly AuthService _authService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public AuthController(AuthService authService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _authService = authService ?? throw new ArgumentNullException(nameof(authService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [CredentialsLogin]
        // POST: api/v1/Auth/CredentialsLogin
        [HttpPost("CredentialsLogin")]
        [AllowAnonymous]
        public async Task<IActionResult> CredentialsLogin([FromBody] CredentialsLoginRequestDTO credentialsLoginRequest)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(credentialsLoginRequest.User)
                    || string.IsNullOrWhiteSpace(credentialsLoginRequest.Password))
                {
                    return Unauthorized();
                }

                ApiResponse response = await _authService.CredentialsLogin(credentialsLoginRequest);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotConfirmUser:
                    case CustomStatusCodes.UserBlocked:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
                        }
                    case CustomStatusCodes.Unauthorized:
                        {
                            return Unauthorized(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, credentialsLoginRequest));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, credentialsLoginRequest));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, credentialsLoginRequest));
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
