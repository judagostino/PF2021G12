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
    public class SearchController : ControllerBase
    {
        private readonly SearchService _searchService;
        //private readonly ChannelsService _channelsService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly NLog.ILog _logger;

        public SearchController(SearchService searchService, IHttpContextAccessor httpContextAccessor, NLog.ILog logger)
        {
            _searchService = searchService ?? throw new ArgumentNullException(nameof(searchService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }


        #region [Search]
        // POST: api/v1/Search
        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> GetSearch([FromBody] SearchBodyDTO searchBody)
        {
            try
            {
                ApiResponse response = await _searchService.GetSearch(searchBody);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, searchBody));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, searchBody));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, searchBody));
            }
        }
        #endregion
    }
}
