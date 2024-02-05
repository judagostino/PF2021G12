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
    public class PostsController : ControllerBase
    {
        private readonly PostsService _postsService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public PostsController(PostsService postsService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _postsService = postsService ?? throw new ArgumentNullException(nameof(postsService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [Insert]
        // POST: api/v1/Posts
        [HttpPost]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Insert([FromBody] PostsDTO post)
        {
            try
            {
               
                if (string.IsNullOrWhiteSpace(post.Title))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TitleRequired, post));
                }


                if (string.IsNullOrWhiteSpace(post.Description))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.DescriptionRequired, post));
                }

                if (string.IsNullOrWhiteSpace(post.Text))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TextRequired, post));
                }

                ApiResponse response = await _postsService.Insert(post);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                    case CustomStatusCodes.DescriptionRequired:
                    case CustomStatusCodes.TextRequired:
                    case CustomStatusCodes.TitleRequired:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, post));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, post));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, post));
            }
        }
        #endregion

        #region [Update]
        // PUT: api/v1/Posts/postId
        [HttpPut("{postId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Update(int postId, [FromBody] PostsDTO post)
        {
            try
            {
                if (postId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, post));
                }

                if (string.IsNullOrWhiteSpace(post.Title))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TitleRequired, post));
                }


                if (string.IsNullOrWhiteSpace(post.Description))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.DescriptionRequired, post));
                }

                if (string.IsNullOrWhiteSpace(post.Text))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.TextRequired, post));
                }

                ApiResponse response = await _postsService.Update(postId, post);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, post));
                        }
                    case CustomStatusCodes.DescriptionRequired:
                    case CustomStatusCodes.TextRequired:
                    case CustomStatusCodes.TitleRequired:
                    case CustomStatusCodes.RequiredId:
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, post));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, post));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, post));
            }
        }
        #endregion

        #region [Delete]
        // DELETE: api/v1/Posts/PostId
        [HttpDelete("{postId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Delete(int postId)
        {
            try
            {
                if (postId != null && postId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, postId));
                }

                ApiResponse response = await _postsService.Delete(postId);

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
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, postId));
            }
        }
        #endregion

        #region [GetById]
        // GET: api/v1/Posts/EventId
        [HttpGet("{postId}")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetById(int postId)
        {
            try
            {
                if (postId != null && postId <= 0)
                {
                    return BadRequest(CustomStatusCodes.RequiredId);
                }

                ApiResponse response = await _postsService.GetById(postId);

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
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, postId));
            }
        }
        #endregion

        #region [IdMoreInfo]
        // GET: api/v1/Posts/postId/moreInfo
        [HttpGet("{PostId}/moreInfo")]
        [AllowAnonymous]
        public async Task<IActionResult> GetByIdMoreInfo(int postId)
        {
            try
            {
                if (postId != null && postId <= 0)
                {
                    return BadRequest(CustomStatusCodes.RequiredId);
                }

                ApiResponse response = await _postsService.GetByIdMoreInfo(postId);

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
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, postId));
            }
        }
        #endregion

        #region [GetAll]
        // GET: api/v1/Posts?a=1
        [HttpGet]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetAll([FromQuery(Name = "a")] int valideAuditor)
        {
            try
            {
                ApiResponse response = await _postsService.GetAll(valideAuditor);

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
        // POST: api/v1/Posts/PostId/Authorize
        [HttpPost("{postId}/Autorize")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Autorize(int postId)
        {
            try
            {
                ApiResponse response = await _postsService.Autorize(postId);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    case CustomStatusCodes.unauthorizedAction:
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, postId));
            }
        }
        #endregion

        #region [Deny]
        // POST: api/v1/POsts/PostId/Deny
        [HttpPost("{postId}/Deny")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Deny(int postId, [FromBody] DenyDTO deny)
        {
            try
            {
                ApiResponse response;

                if (deny != null && deny.Reason != null && !string.IsNullOrWhiteSpace(deny.Reason))
                {
                    response = await _postsService.Deny(postId, deny.Reason);
                }
                else
                {
                    response = await _postsService.Deny(postId, null);
                }


                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return NotFound(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    case CustomStatusCodes.unauthorizedAction:
                    case CustomStatusCodes.BadRequest:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, postId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, postId));
            }
        }
        #endregion
    }
}
