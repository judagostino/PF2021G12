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
    public class NotifyController : ControllerBase
    {
        private readonly NotifyService _notifyService;
        private readonly EmailService _emailService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly NLog.ILog _logger;

        public NotifyController(NotifyService notifyService, EmailService emailService, IHttpContextAccessor httpContextAccessor, NLog.ILog logger)
        {
            _notifyService = notifyService ?? throw new ArgumentNullException(nameof(notifyService));
            _emailService = emailService ?? throw new ArgumentNullException(nameof(emailService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [NewEventsAndPosts]
        // POST: api/v1/Notify/NewEventsAndPosts
        [HttpPost("NewEventsAndPosts")]
        [AllowAnonymous]
        public async Task<IActionResult> NewEventsAndPosts()
        {
            try
            {

                ApiResponse response = await _notifyService.NewEventsAndPosts();

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            // Send email to user
                            ApiResponse emailResponse = await _emailService.SendEmailNotifyAsync(response);

                            if (emailResponse.Status == CustomStatusCodes.Success)
                            {
                                return Ok();
                            }
                            else
                            {
                                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, emailResponse.Status, response.Data));
                            }
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound();
                        }
                    case CustomStatusCodes.Unauthorized:
                        {
                            return Unauthorized();
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
