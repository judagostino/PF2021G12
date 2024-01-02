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
    public class ContactTypeImplairmentController : ControllerBase
    {
        private readonly ContactTypeImplairmentService _contactTypeImplairmentService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public ContactTypeImplairmentController(ContactTypeImplairmentService contactTypeImplairmentService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _contactTypeImplairmentService = contactTypeImplairmentService ?? throw new ArgumentNullException(nameof(contactTypeImplairmentService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [GetAll]
        // GET: api/v1/ContactTypeImplairment
        [HttpGet]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetAll()
        {
            try
            {

                ApiResponse response = await _contactTypeImplairmentService.GetAll();

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

        #region [Insert]
        // POST: api/v1/ContactTypeImplairment
        [HttpPost]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Insert(ContactTypeImplairmentDTO contactTypeImplairment)
        {
            try
            {
                ApiResponse response = await _contactTypeImplairmentService.Insert(contactTypeImplairment);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }
                    case CustomStatusCodes.ContactIdRequired:
                    case CustomStatusCodes.InvalidType:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactTypeImplairment));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactTypeImplairment));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactTypeImplairment));
            }
        }
        #endregion

        #region [Update]
        // POST: api/v1/ContactTypeImplairment/contactTypeImplairmentId
        [HttpPut("{contactTypeImplairmentId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Update(int contactTypeImplairmentId, ContactTypeImplairmentDTO contactTypeImplairment)
        {
            try
            {
                ApiResponse response = await _contactTypeImplairmentService.Update(contactTypeImplairmentId, contactTypeImplairment);

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
                    case CustomStatusCodes.InvalidType:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactTypeImplairment));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactTypeImplairment));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactTypeImplairment));
            }
        }
        #endregion

        #region [Delete]
        // DELETE: api/v1/ContactEvents/contactTypeImplairmentId
        [HttpDelete("{contactTypeImplairmentId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Delete(int contactTypeImplairmentId)
        {
            try
            {
                if (contactTypeImplairmentId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contactTypeImplairmentId));
                }

                ApiResponse response = await _contactTypeImplairmentService.Delete(contactTypeImplairmentId);

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
                    case CustomStatusCodes.InvalidType:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactTypeImplairmentId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactTypeImplairmentId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactTypeImplairmentId));
            }
        }
        #endregion
    }
}
