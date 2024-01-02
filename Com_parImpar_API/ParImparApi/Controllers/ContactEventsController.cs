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
    public class ContactEventsController : ControllerBase
    {
        private readonly ContactEventsService _contactEventsService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public ContactEventsController(ContactEventsService contactEventsService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _contactEventsService = contactEventsService ?? throw new ArgumentNullException(nameof(contactEventsService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [GetAllAssistEvents]
        // GET: api/v1/ContactEvents
        [HttpGet]
        [Authorize("AccessToken")]
        public async Task<IActionResult> AllAssistEvents()
        {
            try
            {

                ApiResponse response = await _contactEventsService.GetAll();

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.ContactIdRequired:
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

        #region [AssistEventById]
        // GET: api/v1/ContactEvents/EventId
        [HttpGet("{EventId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> AssistEventById(int eventId)
        {
            try
            {
                if (eventId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, eventId));
                }

                ApiResponse response = await _contactEventsService.GetById(eventId);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound();
                        }
                    case CustomStatusCodes.ContactIdRequired:
                    case CustomStatusCodes.RequiredId:
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

        #region [InsertAssistEvent]
        // POST: api/v1/ContactEvents
        [HttpPost]
        [Authorize("AccessToken")]
        public async Task<IActionResult> InsertAssistEvent(ContactXEventDTO contactXEvent)
        {
            try
            {
                if (contactXEvent  == null || (contactXEvent != null && contactXEvent.EventId <= 0))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contactXEvent));
                }

                ApiResponse response = await _contactEventsService.Insert(contactXEvent.EventId);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }
                    case CustomStatusCodes.ContactIdRequired:
                    case CustomStatusCodes.RequiredId:
                    case CustomStatusCodes.InvalidDateEvent:
                    case CustomStatusCodes.InvalidEvent:
                    case CustomStatusCodes.ExistContactEvent:                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactXEvent));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactXEvent));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactXEvent));
            }
        }
        #endregion

        #region [CancelAssistEvent]
        // DELETE: api/v1/ContactEvents/EventId
        [HttpDelete("{EventId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> CancelAssistEvent(int eventId)
        {
            try
            {
                if (eventId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, eventId));
                }

                ApiResponse response = await _contactEventsService.Cancellation(eventId);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok();
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound();
                        }
                    case CustomStatusCodes.ContactIdRequired:
                    case CustomStatusCodes.RequiredId:
                    case CustomStatusCodes.InvalidDateEvent:
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
