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
            string subject = "Se ha creado tu usuario en Comunidad ParImpar";
            string message = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>Comunidad ParImpar</title></head><body style=\"padding: 0px; margin: 0px; align-content: center; border: 1px solid black;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" ><tr><td align=\"left\" style=\"height: 50px; border-bottom: 1px solid #999999; background-color: #F4F4F4\"></tr><tr><td align=\"left\" style=\"padding-left: 20px; padding-right: 20px; padding-top: 20px\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"15\" style=\"font-family: Trebuchet MS, Helvetica, sans-serif;font-size: 16px;\"><tr><td align=\"left\">Hola, [FirstName].</td></tr><tr><td align=\"left\">Te has registrado como usuario de Comunidad ParImpar con el nombre de usuario [UserName]. Para completar tu registro haz clic en el siguiente botón:</td></tr><tr><td align=\"center\" style=\"cursor:none; padding-top: 10px;\"><a href=\"[SiteAdminUrl]/user/confirm?[PasswordRecoveryToken]\" style=\"text-decoration: none;\"><div style=\"cursor: pointer; width: 200px; border-radius: 5px; background-color: #22707d; padding-left: 15px; padding-right: 15px; padding-top: 15px; padding-bottom: 15px; color: #ffffff; text-align: center; vertical-align: middle;\">Confirmar registro</div></a></td></tr><tr><td align=\"left\" style=\"padding-top: 20px\">Gracias.</td></tr><tr><td align=\"left\" style=\"padding-top: 30px\">El equipo de Comunidad ParImpar</td></tr></table></td></tr></table></body></html>";
            string token = "c=" + registerUser.Id + "c=" + registerUser.ConfirmCode;

            message = message.Replace("[FirstName]", registerUser.FirstName);
            message = message.Replace("[UserName]", registerUser.UserName);
            message = message.Replace("[SiteAdminUrl]", "http://Localhost:4200");
            message = message.Replace("[PasswordRecoveryToken]", token);
            
            return await SendEmailAsync(subject, message, registerUser.Email);
        }

        public async Task<ApiResponse> SendEmailRecoverPasswordAsync(RegisterUserDTO registerUser) {
            string subject = "Recuperar contraseña";
            string message = "< !DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>Comunidad ParImpar</title></head><body style=\"padding: 0px; margin: 0px; border: 1px solid black;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"background-color: #f4f4f4; padding-top: 20px; padding-bottom: 20px;\"></td></tr><tr><td style=\"background-color: transparent; padding-left: 20px; padding-right: 20px; padding-top: 20px; padding-bottom: 30px\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"15\" style=\"font-family: Arial; font-size: 16px;\"><tr><td align=\"left\">Hola [FirstName]!</td></tr><tr><td align=\"left\">Has solicitado recuperar tu contraseña de Comunidad ParImpar. Por favor clickea en el siguiente enlace para finalizar el proceso</td></tr><tr><td align=\"center\" style=\"cursor:none; padding-top: 10px;\"><a href=\"[SiteAdminUrl]/user/change?[PasswordRecoveryToken]\" style=\"text-decoration: none;\"><div style=\"cursor: pointer; width: 200px; border-radius: 5px; background-color: #22707d; padding-left: 15px; padding-right: 15px; padding-top: 15px; padding-bottom: 15px; color: #ffffff; text-align: center; vertical-align: middle;\">Cambiar mi contraseña</div></a></td></tr><tr><td align=\"left\" style=\"padding-top:30px\"><b>¿No solicitaste este cambio?</b></td></tr><tr><td align=\"left\">Si no solicitaste la recuperación de tu contraseña sigue el siguiente enlace y háznoslo saber</td></tr><tr><td align=\"center\" style=\"padding-top: 10px;\"><a href=\"[SiteAdminUrl]/user/cancel?[PasswordRecoveryToken]\" style=\"text-decoration: none;\"><div style=\"width: 200px; border-radius: 5px; background-color: #CCCCCC; padding-left: 15px; padding-right: 15px; padding-top: 15px; padding-bottom: 15px; color: #333333; text-align: center; vertical-align: middle;\">Cancelar solicitud</div></a></td></tr><tr><td align=\"left\" style=\"padding-top: 30px;\">Equipo de Comunidad ParImpar.</td></tr></table></td></tr></table></body></html>";
            string token = "c=" + registerUser.Id + "c=" + registerUser.ConfirmCode;

            message = message.Replace("[FirstName]", registerUser.FirstName);
            message = message.Replace("[UserName]", registerUser.UserName);
            message = message.Replace("[SiteAdminUrl]", "http://Localhost:4200");
            message = message.Replace("[PasswordRecoveryToken]", token);

            return await SendEmailAsync(subject, message, registerUser.Email);
        }

        public async Task<ApiResponse> SendEmailAsync(string subject, string message, string Email)
        {

            MailMessage mailMessage = new MailMessage();

            mailMessage.From = new MailAddress("comunidadparimpar@gmail.com", "Comunidad ParImpar");
            mailMessage.To.Add(Email);
            mailMessage.Subject = subject;
            mailMessage.Body = message;
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
