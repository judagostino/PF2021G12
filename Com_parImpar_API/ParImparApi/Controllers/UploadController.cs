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
    public class UploadController : ControllerBase
    {
        private readonly UploadService _uploadService;
        //private readonly ChannelsService _channelsService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly NLog.ILog _logger;

        public UploadController(UploadService uploadService, IHttpContextAccessor httpContextAccessor, NLog.ILog logger)
        {
            _uploadService = uploadService ?? throw new ArgumentNullException(nameof(uploadService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }


        #region [UploadFile]
        //POST: api/v1/Upload
        [HttpPost, DisableRequestSizeLimit]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Upload()
        {
            try
            {

                var formCollection = await Request.ReadFormAsync();
                ApiResponse response;

                if (formCollection.Files == null || formCollection.Files.Count == 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.FileRequired, null));
                }

                string uploadType = formCollection["Type"];
                if (string.IsNullOrEmpty(uploadType) == false)
                {
                    response = await _uploadService.UploadImage(formCollection);

                    switch (response.Status)
                    {
                        case CustomStatusCodes.Success:
                            {
                                return Ok(response.Data);
                            }
                        case CustomStatusCodes.NotFound:
                            {
                                return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
                            }
                        case CustomStatusCodes.Unauthorized:
                            {
                                return Unauthorized(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
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
                else
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TypeRequired, null));
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
