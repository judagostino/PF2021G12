using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Net.Mail;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class EmailService
    {
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EmailService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> SendEmailConfirmAsync(RegisterUserDTO registerUser) {
            return await SendEmailAsync(1, registerUser.Email);
        }

        public async Task<ApiResponse> SendEmailRecoverPasswordAsync(RegisterUserDTO registerUser)
        {
            return await SendEmailAsync(1, registerUser.Email);
        }

        public async Task<ApiResponse> SendEmailAsync(int Type, string Email)
        {

            MailMessage mailMessage = new MailMessage();

            mailMessage.From = new MailAddress("comunidadparimpar@gmail.com", "Comunidad ParImpar");
            mailMessage.To.Add(Email);
            mailMessage.Subject = "prueba";
            mailMessage.Body = "<H1> Esto es una prueba </H1>";
            mailMessage.IsBodyHtml = true;
            mailMessage.Priority = MailPriority.Normal;
            try
            {
                SmtpClient smtp = new SmtpClient();
                smtp.UseDefaultCredentials = false;
                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                smtp.EnableSsl = true;

                smtp.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                //Solo si necesita usuario y clave
                smtp.Credentials = new System.Net.NetworkCredential("comunidadparimpar@gmail.com", "eDejd1iJB2");

                await smtp.SendMailAsync(mailMessage);

                return new ApiResponse();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
