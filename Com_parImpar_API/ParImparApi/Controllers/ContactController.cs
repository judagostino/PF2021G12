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
    public class ContactController : ControllerBase
    {
        private readonly AuthService _authService;
        private readonly ContactsService _contactsService;
        private readonly EmailService _emailService;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILog _logger;

        public ContactController(AuthService authService, ContactsService contactsService, EmailService emailService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, ILog logger)
        {
            _contactsService = contactsService ?? throw new ArgumentNullException(nameof(contactsService));
            _authService = authService ?? throw new ArgumentNullException(nameof(authService));
            _emailService = emailService ?? throw new ArgumentNullException(nameof(emailService));
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region [Register]
        // POST: api/v1/Contact/Register
        [HttpPost("Register")]
        [AllowAnonymous]
        public async Task<IActionResult> RegistrerUser([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(registerUser.Email) || string.IsNullOrWhiteSpace(registerUser.ConfirmEmail))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.EmailRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.UserName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.UserNameRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.FirstName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.FirstNameRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.LastName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.LastNameRequiredField, registerUser));
                }
                if (string.IsNullOrWhiteSpace(registerUser.Password) || string.IsNullOrWhiteSpace(registerUser.ConfirmPassword))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.PasswordRequiredField, registerUser));
                }

                ApiResponse response = await _contactsService.RegistrerUser(registerUser);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            // Send email to user
                            ApiResponse emailResponse = await _emailService.SendEmailConfirmAsync(registerUser);

                            if (emailResponse.Status == CustomStatusCodes.Success)
                            {
                                return Ok();
                            }
                            else
                            {
                                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, emailResponse.Status, registerUser));
                            }
                        }
                    case CustomStatusCodes.DistintEmail:
                    case CustomStatusCodes.EmailExist:
                    case CustomStatusCodes.EmailRequiredField:
                    case CustomStatusCodes.UserNameRequiredField:
                    case CustomStatusCodes.FirstNameRequiredField:
                    case CustomStatusCodes.LastNameRequiredField:
                    case CustomStatusCodes.PasswordRequiredField:
                    case CustomStatusCodes.DistintPassword:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [RecoverPassword]
        // POST: api/v1/Contact/Recover
        [HttpPost("Recover")]
        [AllowAnonymous]
        public async Task<IActionResult> RecoverPassword([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(registerUser.Email) || string.IsNullOrWhiteSpace(registerUser.ConfirmEmail))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.EmailRequiredField, registerUser));
                }
            
                ApiResponse response = await _contactsService.RecoverPassword(registerUser);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            // Send email to user
                            ApiResponse emailResponse = await _emailService.SendEmailRecoverPasswordAsync(registerUser);

                            if (emailResponse.Status == CustomStatusCodes.Success)
                            {
                                return Ok(response.Data);
                            }
                            else
                            {
                                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, emailResponse.Status, registerUser));
                            }
                        }
                    case CustomStatusCodes.ExpiredLink:
                    case CustomStatusCodes.DistintEmail:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [Confirm]
        // POST: api/v1/Contact/Confirm
        [HttpPost("Confirm")]
        [AllowAnonymous]
        public async Task<IActionResult> Confirm([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (!(registerUser != null 
                    && registerUser.Id != null 
                    && registerUser.Id != 0 
                    && registerUser.ConfirmCode != null 
                    && !registerUser.ConfirmCode.Equals("")
                    && !string.IsNullOrWhiteSpace(registerUser.ConfirmCode)))
                {
                    return BadRequest();
                }
             
                ApiResponse response = await _contactsService.Confirm(registerUser);


                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [ValidarteRecover]
        // POST: api/v1/Contact/Validate
        [HttpPost("Validate")]
        [AllowAnonymous]
        public async Task<IActionResult> ValidarteRecover([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (!(registerUser != null 
                    && registerUser.Id != null 
                    && registerUser.Id != 0 
                    && registerUser.CodeRecover != null 
                    && !registerUser.CodeRecover.Equals("")
                    && !string.IsNullOrWhiteSpace(registerUser.CodeRecover)))
                {
                    return BadRequest();
                }
             
                ApiResponse response = await _contactsService.ValidarteRecover(registerUser);


                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.ExpiredLink:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [DenyRecover]
        // POST: api/v1/Contact/Deny
        [HttpPost("Deny")]
        [AllowAnonymous]
        public async Task<IActionResult> DenyRecover([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (!(registerUser != null
                    && registerUser.Id != null
                    && registerUser.Id != 0
                    && registerUser.CodeRecover != null
                    && !registerUser.CodeRecover.Equals("")
                    && !string.IsNullOrWhiteSpace(registerUser.CodeRecover)))
                {
                    return BadRequest();
                }

                ApiResponse response = await _contactsService.DenyRecover(registerUser);


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
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [RecoverChange]
        // POST: api/v1/Contact/RecoverChange
        [HttpPost("RecoverChange")]
        [AllowAnonymous]
        public async Task<IActionResult> RecoverChange([FromBody] RegisterUserDTO registerUser)
        {
            try
            {
                if (!(registerUser != null 
                    && registerUser.Id != null 
                    && registerUser.Id != 0 
                    && registerUser.CodeRecover != null 
                    && !registerUser.CodeRecover.Equals("")
                    && !string.IsNullOrWhiteSpace(registerUser.CodeRecover)))
                {
                    return BadRequest();
                }

                if (string.IsNullOrWhiteSpace(registerUser.Password) || string.IsNullOrWhiteSpace(registerUser.ConfirmPassword))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.PasswordRequiredField, registerUser));
                }

                ApiResponse response = await _contactsService.RecoverChange(registerUser);


                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(response.Data);
                        }
                    case CustomStatusCodes.ExpiredLink:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, registerUser));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, registerUser));
            }
        }
        #endregion

        #region [ChangePassword]
        // POST: api/v1/Contact/ChangePassword
        [HttpPost("ChangePassword")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequestDTO changePassword)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(changePassword.LastPassword))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.PasswordRequiredField, null));
                }

                if (string.IsNullOrWhiteSpace(changePassword.NewPassword))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.NewPasswordRequired, null));
                }

                if (string.IsNullOrWhiteSpace(changePassword.ConfirmPassword))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.ConfirmPasswordRequired, null));
                }

                ApiResponse response = await _contactsService.ChangePassword(changePassword);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }

                    case CustomStatusCodes.NotChangePassword:
                    case CustomStatusCodes.IncorretFormatPassword:
                    case CustomStatusCodes.DistintPassword:
                        {
                             return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return StatusCode(StatusCodes.Status401Unauthorized, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
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

        #region [GetContactId]
        // POST: api/v1/Contact/ContactId
        [HttpGet("{ContactId}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetById(int contactId)
        {
            try
            {
                ApiResponse response = await _contactsService.GetById(contactId, 1);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return StatusCode(StatusCodes.Status401Unauthorized, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
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

        #region [GetContactId_Information]
        // POST: api/v1/Contact/ContactId/Information
        [HttpGet("{ContactId}/Information")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetByIdInformation(int contactId)
        {
            try
            {
                ApiResponse response = await _contactsService.GetByIdInformation(contactId);

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
                    case CustomStatusCodes.unauthorizedAction:
                    {
                        return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
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

        #region [GetContactId_myInfo]
        // GET: api/v1/Contact/myInfo
        [HttpGet("myInfo")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> MyInfo()
        {
            try
            {
                ApiResponse response = await _contactsService.GetById(null, 0);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok(((ApiSuccessResponse)response.Data));
                        }
                    case CustomStatusCodes.NotFound:
                        {
                            return StatusCode(StatusCodes.Status401Unauthorized, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, null));
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

        #region [Update]
        // PUT: api/v1/Contact
        [HttpPut]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Update([FromBody] ContactDTO contact)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(contact.UserName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.UserNameRequiredField, contact));
                }
                if (string.IsNullOrWhiteSpace(contact.FirstName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.FirstNameRequiredField, contact));
                }
                if (string.IsNullOrWhiteSpace(contact.LastName))
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.LastNameRequiredField, contact));
                }

                ApiResponse response = await _contactsService.Update(contact);

                switch (response.Status)
                {
                    case CustomStatusCodes.Success:
                        {
                            return Ok();
                        }
                    case CustomStatusCodes.UserNameRequiredField:
                    case CustomStatusCodes.FirstNameRequiredField:
                    case CustomStatusCodes.LastNameRequiredField:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contact));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contact));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contact));
            }
        }
        #endregion

        #region [Untrusted]
        // PUT: api/v1/Contact/ContactId/untrusted
        [HttpPut("{ContactId}/untrusted")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Untrusted(int contactId)
        {
            try
            {
                if (contactId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contactId));
                }

                ApiResponse response = await _contactsService.TrustedAndUntrusted(contactId, false);

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
                    case CustomStatusCodes.unauthorizedAction:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactId));
            }
        }
        #endregion

        #region [Trusted]
        // PUT: api/v1/Contact/ContactId/trusted
        [HttpPut("{ContactId}/trusted")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Trusted(int contactId)
        {
            try
            {
                if (contactId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contactId));
                }

                ApiResponse response = await _contactsService.TrustedAndUntrusted(contactId, true);

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
                    case CustomStatusCodes.unauthorizedAction:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactId));
            }
        }
        #endregion

        #region [Unblocked]
        // PUT: api/v1/Contact/ContactId/Unblocked
        [HttpPut("{ContactId}/Unblocked")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Unblocked(int contactId)
        {
            try
            {
                if (contactId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contactId));
                }

                ApiResponse response = await _contactsService.Unblocked(contactId);

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
                    case CustomStatusCodes.unauthorizedAction:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactId));
            }
        }
        #endregion

        #region [Blocked]
        // PUT: api/v1/Contact/ContactId/Blocked
        [HttpPut("{ContactId}/Blocked")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Blocked(int contactId)
        {
            try
            {
                if (contactId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contactId));
                }

                ApiResponse response = await _contactsService.Blocked(contactId);

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
                    case CustomStatusCodes.unauthorizedAction:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contactId));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contactId));
            }
        }
        #endregion

        #region [Auditor]
        // PUT: api/v1/Contact/ContactId/Auditor
        [HttpPut("{ContactId}/Auditor")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> Auditor(int contactId, [FromBody] ContactDTO contact)
        {
            try
            {
                if (contactId <= 0)
                {
                    return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, CustomStatusCodes.RequiredId, contact));
                }

                ApiResponse response = await _contactsService.Auditor(contactId, contact);

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
                    case CustomStatusCodes.unauthorizedAction:
                        {
                            return BadRequest(Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contact));
                        }
                    default:
                        {
                            return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateErrorResponse(_httpContextAccessor.HttpContext, _logger, response.Status, contact));
                        }
                }
            }
            catch (Exception exc)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, Functions.GenerateExceptionResponse(_httpContextAccessor.HttpContext, _logger, exc, contact));
            }
        }
        #endregion

        #region [GetAll]
        // PUT: api/v1/Contact/GetAll
        [HttpGet("GetAll")]
        [Authorize("AccessToken")]
        public async Task<IActionResult> GetAll()
        {
            try
            {
                ApiResponse response = await _contactsService.GetAll();

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
                    case CustomStatusCodes.unauthorizedAction:
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
