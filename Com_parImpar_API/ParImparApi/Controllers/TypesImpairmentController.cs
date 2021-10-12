using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ParImparApi.Common;
using ParImparApi.Services;

namespace ParImparApi.Controllers
{
    [ApiController]
    [Route("api/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    public class TypesImpairmentController : ControllerBase
    {
        private readonly TypesImpairmentService _typesImpairmentService;
        //private readonly ChannelsService _channelsService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly NLog.ILog _logger;

        public TypesImpairmentController(TypesImpairmentService typesImpairmentService, IHttpContextAccessor httpContextAccessor, NLog.ILog logger)
        {
            _typesImpairmentService = typesImpairmentService ?? throw new ArgumentNullException(nameof(typesImpairmentService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }


        #region [GetAll]
        //Get: api/v1/TypesImpairment
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> GetAll()
        {
            try
            {
                ApiResponse response = await _typesImpairmentService.GetAll();

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response);
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
