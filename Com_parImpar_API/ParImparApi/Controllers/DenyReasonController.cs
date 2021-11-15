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
    public class DenyReasonController : ControllerBase
    {
        private readonly AuxiliarService _auxiliarService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public DenyReasonController(AuxiliarService auxiliarService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _auxiliarService = auxiliarService ?? throw new ArgumentNullException(nameof(auxiliarService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [GetById]
        // GET: api/v1/DenyReason/key/id
        [HttpGet("{key}/{id}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetById(string key, int id)
        {
            try
            {
                if (!(key != null && !string.IsNullOrEmpty(key) && id > 0))
                {
                    return BadRequest(CustomStatusCodes.RequiredId);
                }

                if (key.ToLower().Equals("eventid"))
                {
                    key = "EventId";
                } else if (key.ToLower().Equals("postid"))
                {
                    key = "PostId";
                } else
                {
                    key = "Null";
                }

                ApiResponse response = await _auxiliarService.GetByKeyAndId(key, id);

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
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, key + "-" + id));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, key + "-" + id));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, key + "-" + id));
            }
        }
        #endregion
    }
}
