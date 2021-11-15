using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.NLog;
using ParImparApi.Services;

namespace ParImparApi.Controllers
{
    [ApiController]
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    public class ActionsLogController : ControllerBase
    {
        private readonly ActionLogService _actionLogService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public ActionsLogController(ActionLogService actionLogService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _actionLogService = actionLogService ?? throw new ArgumentNullException(nameof(actionLogService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [GetAll]
        // GET: api/v1/ActionsLog
        [HttpGet]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetAll()
        {
            try
            {
                ApiResponse response = await _actionLogService.GetAll();

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound();
                        }
                    case CustomStatusCodes.Unauthorized:
                        {
                            return Unauthorized();
                        }
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
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
