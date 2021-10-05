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

        /*public UploadController(UploadService uploadService, ChannelsService channelsService, IHttpContextAccessor httpContextAccessor, NLog.ILog logger)
        {
            _uploadService = uploadService ?? throw new ArgumentNullException(nameof(uploadService));
            _channelsService = channelsService ?? throw new ArgumentNullException(nameof(channelsService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }*/


        /*#region [UploadFile]
        //POST: api/v1/Upload
        [HttpPost, DisableRequestSizeLimit]
        [Authorize]
        public async Task<IActionResult> Upload()
        {
            try
            {
                var formCollection = await Request.ReadFormAsync();

                string uploadType = formCollection["Type"];
                ApiResponse response;

                if (formCollection.Files == null || formCollection.Files.Count == 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.FileRequired, null));
                }

                if (string.IsNullOrEmpty(uploadType) == false)
                {
                    switch (uploadType.ToLower())
                    {
                        case "channelimage":
                            {
                                response = await UploadChannelImage(formCollection);

                                break;
                            }
                        case "organizationimage":
                            {
                                response = await UploadOrganizationImage(formCollection);

                                break;
                            }
                        case "contentnewimage":
                            {
                                response = await UploadContentNewImage(formCollection);

                                break;
                            }
                        case "contentviewimage":
                            {
                                response = await UploadContentViewImage(formCollection);

                                break;
                            }
                        default:
                            {
                                return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.InvalidType, null));
                            }
                    }

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
                        case CustomStatusCodes.IdRequired:
                        case CustomStatusCodes.OrgIdRequired:
                        case CustomStatusCodes.UoIdRequired:
                        case CustomStatusCodes.FileIsEmpty:
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

                //var file = formCollection.Files.First();
                //string channelId = formCollection["ChannelId"];

                //var folderName = Path.Combine("Resources", "Images");
                //var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                //if (file.Length > 0)
                //{
                //    var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                //    var fullPath = Path.Combine(pathToSave, fileName);
                //    var dbPath = Path.Combine(folderName, fileName);
                //    using (var stream = new FileStream(fullPath, FileMode.Create))
                //    {
                //        file.CopyTo(stream);
                //    }
                //    return Ok(new { dbPath });
                //}
                //else
                //{
                //    return BadRequest();
                //}
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, null));
            }
        }
        #endregion*/


    }
}
