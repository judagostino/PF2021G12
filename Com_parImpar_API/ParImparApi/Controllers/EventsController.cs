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
    public class EventsController : ControllerBase
    {
        private readonly EventsService _eventsService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public EventsController(EventsService eventsService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _eventsService = eventsService ?? throw new ArgumentNullException(nameof(eventsService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [Insert]
        // POST: api/v1/Events
        [HttpPost]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Insert([FromBody] EventRequestDTO eventRequest)
        {
            try
            {
                if (eventRequest.StartDate == null)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.StartDateRequired, eventRequest));
                }

                if (string.IsNullOrWhiteSpace(eventRequest.Title))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TitleRequired, eventRequest));
                }

                ApiResponse response = await _eventsService.Insert(eventRequest);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                    case CustomStatusCodes.StartDateRequired:
                    case CustomStatusCodes.TitleRequired:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventRequest));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventRequest));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, eventRequest));
            }
        }
        #endregion

        #region [Update]
        // PUT: api/v1/Events/EventId
        [HttpPut("{EventId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Update(int eventId, [FromBody] EventRequestDTO eventRequest)
        {
            try
            {
                if (eventId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, eventRequest));
                }

                if (eventRequest.StartDate == null)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.StartDateRequired, eventRequest));
                }

                if (string.IsNullOrWhiteSpace(eventRequest.Title))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TitleRequired, eventRequest));
                }

                ApiResponse response = await _eventsService.Update(eventId, eventRequest);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventRequest));
                        }
                    case CustomStatusCodes.StartDateRequired:
                    case CustomStatusCodes.TitleRequired:
                    case CustomStatusCodes.RequiredId:
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventRequest));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventRequest));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, eventRequest));
            }
        }
        #endregion

        #region [Delete]
        // DELETE: api/v1/Events/EventId
        [HttpDelete("{EventId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Delete(int eventId)
        {
            try
            {
                if (eventId != null && eventId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, eventId));
                }

                ApiResponse response = await _eventsService.Delete(eventId);

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
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, eventId));
            }
        }
        #endregion

        #region [GetById]
        // GET: api/v1/Events/EventId
        [HttpGet("{EventId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetById(int eventId)
        {
            try
            {
                if (eventId != null && eventId <= 0)
                {
                    return BadRequest(CustomStatusCodes.RequiredId);
                }

                ApiResponse response = await _eventsService.GetById(eventId);

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
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, eventId));
            }
        }
        #endregion

        #region [GetAll]
        // GET: api/v1/Events
        [HttpGet]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetAll()
        {
            try
            {
                ApiResponse response = await _eventsService.GetAll();

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

        #region [Authorize]
        // POST: api/v1/Events/Authorize
        [HttpPost("{EventId}/Autorize")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Autorize(int eventId)
        {
            try
            {
                ApiResponse response = await _eventsService.Autorize(eventId);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                    case CustomStatusCodes.unauthorizedAction:
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, eventId));
            }
        }
        #endregion

        #region [Deny]
        // POST: api/v1/Events/Deny
        [HttpPost("{EventId}/Deny")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Deny(int eventId)
        {
            try
            {
                ApiResponse response = await _eventsService.Deny(eventId);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                    case CustomStatusCodes.unauthorizedAction:
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, eventId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, eventId));
            }
        }
        #endregion
    }
}
