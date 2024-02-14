using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace ParImparApi.Services
{
    public class EmailService
    {
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public EmailService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> SendEmailNotifyAsync(ApiResponse response)
        {
             List<ContactDTO> contacts = (List<ContactDTO>)response.Data;
            List<Task> emailTasks = new List<Task>();

            string subjectTemplate = "¡Hey[NameUser]! ¡Te Contamos las Últimas Novedades en Comunidad ParImpar! 🚀";
            string messageTemplate = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>Comunidad ParImpar</title></head><body style=\"padding: 0px; margin: 20px; align-content: center; border: 1px solid black; background-color: #eeeeee;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #dee3ff;\"><tr><td align=\"left\" style=\"padding-left: 20px; padding-right: 20px; padding-top: 10px\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"15\" style=\"font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 17px;\"><tr><td align=\"left\">¡Hola [NameUser]!</td></tr><tr><td align=\"left\">¿Cómo estás? ¡Esperamos que estés teniendo un día genial! ☀️ Nosotros estamos emocionados de contarte las últimas novedades que ocurrieron por aquí.</td></tr>[PostsContainer][EventsContainer]<tr><td align=\"left\" style=\"padding-top: 10px\">Gracias por ser parte de la familia Comunidad ParImpar. ¡Que tengas un día tan increíble!</td></tr><tr><td align=\"left\" style=\"padding-top: 30px; padding-bottom: 15px;\">Con cariño,<br>El Equipo de  Comunidad ParImpar 🚀✨</td></tr></table></td></tr></table></body></html>";
            string postsTemplate = "<tr><td align=\"left\" ><div style=\"color: #2a41c2; font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 24px;\">📚 Nuevos Posts que pueden interesarte:</div><div style=\"font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 17px; padding-bottom: 15px; padding-top: 8px;\">Sabemos que te pueden gustar muchos temas, y aquí tienes algunos de los nuevos Post que han publicado y que pueden llamarte la atención. ¡Échales un vistazo!</div><div style=\"padding-left: 25px; display: inline-grid;\">[PostList]</div></td></tr>";
            string postTemplate = "<div style=\"display: inline-flex;\"><div style=\"margin-right: 15px; color: #2a41c2;\">●</div><a href=\"[PostURL]\" style=\"color: #7b89db; font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 20px;\" target=\"_blank\">[PostTitle]</a></div>";
            string eventsTemplate = "<tr><td align=\"left\" ><div style=\"color: #2a41c2; font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 24px;\">🎉 Cambios en tus Eventos:</div><div style=\"font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 17px; padding-bottom: 15px; padding-top: 8px;\">¿Recuerdas esos eventos asombrosos que marcaste en tu calendario? Pues bien, han habido algunos cambios emocionantes que pensamos que te gustaría saber</div><div style=\"padding-left: 25px; display: inline-grid;\">[EventList]</div></td></tr>";
            string eventTemplate = "<div style=\"display: inline-flex;\"><div style=\"margin-right: 15px; color: #2a41c2;\">●</div><a href=\"[EventURL]\" style=\"color: #7b89db; font-family: Roboto, 'Helvetica Neue', sans-serif; font-size: 20px;\" target=\"_blank\">[EventTitle]</a></div>";

            for (int i = 0; i < contacts.Count; i++) {
                ContactDTO contact = contacts[i];
                if ((contact.Posts != null && contact.Posts.Count > 0) || (contact.Events != null && contact.Events.Count > 0)) {
                    string subject = subjectTemplate;
                    string message = messageTemplate;
                    string posts = postsTemplate;
                    string evetns = eventsTemplate;
                    string host = _configuration["GlobalVariables:Host"];

                    if (contact.FirstName != null && !contact.FirstName.Equals(""))
                    {
                        subject = subject.Replace("[NameUser]",  " " + contact.FirstName);
                        message = message.Replace("[NameUser]", " " + contact.FirstName);
                    } else
                    {
                        subject = subject.Replace("[NameUser]", "");
                        message = message.Replace("[NameUser]", "");
                    }

                    // Hay Posts
                    if (contact.Posts != null && contact.Posts.Count > 0)
                    {
                        string postsStrings = "";
                        for (int j = 0; j < contact.Posts.Count; j++)
                        {
                            string postStrings = postTemplate;

                            PostsDTO post = contact.Posts[j];

                            postStrings = postStrings.Replace("[PostURL]", host + "/posts-info/" + post.Id);
                            postStrings = postStrings.Replace("[PostTitle]", post.Title);

                            postsStrings = postsStrings + postStrings;
                        }
                        posts = posts.Replace("[PostList]", postsStrings);

                        message = message.Replace("[PostsContainer]", posts);
                    } else
                    {
                        message = message.Replace("[PostsContainer]", "");
                    }

                    // Hay eventos
                    if (contact.Events != null && contact.Events.Count > 0)
                    {
                        string EventsStrings = "";
                        for (int j = 0; j < contact.Events.Count; j++)
                        {
                            string eventString = eventTemplate;
                            EventRequestDTO eventRequest = contact.Events[j];

                            eventString = eventString.Replace("[EventURL]", host + "/events-info/" + eventRequest.Id);
                            eventString = eventString.Replace("[EventTitle]", eventRequest.Title + " (" + eventRequest.StartDate.ToString() + ")");

                            EventsStrings = EventsStrings + eventString;
                        }
                        evetns = evetns.Replace("[EventList]", EventsStrings);

                        message = message.Replace("[EventsContainer]", evetns);
                    }
                    else
                    {
                        message = message.Replace("[EventsContainer]", "");
                    }

                    emailTasks.Add(SendEmailAsync(subject, message, contact.Email));
                }
            }

            await Task.WhenAll(emailTasks);
            
            return new ApiResponse()
            {
                Data = null,
                Status = CustomStatusCodes.Success
            };
        }


        public async Task<ApiResponse> SendEmailConfirmAsync(RegisterUserDTO registerUser) {
            string subject = "Se ha creado tu usuario en Comunidad ParImpar";
            string message = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>Comunidad ParImpar</title></head><body style=\"padding: 0px; margin: 0px; align-content: center; border: 1px solid black;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" ><tr><td align=\"left\" style=\"height: 50px; border-bottom: 1px solid #999999; background-color: #F4F4F4\"></tr><tr><td align=\"left\" style=\"padding-left: 20px; padding-right: 20px; padding-top: 20px\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"15\" style=\"font-family: Trebuchet MS, Helvetica, sans-serif;font-size: 16px;\"><tr><td align=\"left\">Hola, [FirstName].</td></tr><tr><td align=\"left\">Te has registrado como usuario de Comunidad ParImpar con el nombre de usuario [UserName]. Para completar tu registro haz clic en el siguiente botón:</td></tr><tr><td align=\"center\" style=\"cursor:none; padding-top: 10px;\"><a href=\"[SiteAdminUrl]/login?[PasswordRecoveryToken]\" style=\"text-decoration: none;\"><div style=\"cursor: pointer; width: 200px; border-radius: 5px; background-color: #22707d; padding-left: 15px; padding-right: 15px; padding-top: 15px; padding-bottom: 15px; color: #ffffff; text-align: center; vertical-align: middle;\">Confirmar registro</div></a></td></tr><tr><td align=\"left\" style=\"padding-top: 20px\">Gracias.</td></tr><tr><td align=\"left\" style=\"padding-top: 30px\">El equipo de Comunidad ParImpar</td></tr></table></td></tr></table></body></html>";
            string token = "i=" + registerUser.Id + "&c=" + registerUser.ConfirmCode;

            message = message.Replace("[FirstName]", registerUser.FirstName);
            message = message.Replace("[UserName]", registerUser.UserName);
            message = message.Replace("[SiteAdminUrl]", _configuration["GlobalVariables:Host"]);
            message = message.Replace("[PasswordRecoveryToken]", token);
            
            return await SendEmailAsync(subject, message, registerUser.Email);
        }

        public async Task<ApiResponse> SendEmailRecoverPasswordAsync(RegisterUserDTO registerUser) {
            string subject = "Recuperar contraseña";
            string message = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>Comunidad ParImpar</title></head><body style=\"padding: 0px; margin: 0px; border: 1px solid black;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"background-color: #f4f4f4; padding-top: 20px; padding-bottom: 20px;\"></td></tr><tr><td style=\"background-color: transparent; padding-left: 20px; padding-right: 20px; padding-top: 20px; padding-bottom: 30px\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"15\" style=\"font-family: Arial; font-size: 16px;\"><tr><td align=\"left\">Hola [FirstName]!</td></tr><tr><td align=\"left\">Has solicitado recuperar tu contraseña de Comunidad ParImpar. Por favor clickea en el siguiente enlace para finalizar el proceso</td></tr><tr><td align=\"center\" style=\"cursor:none; padding-top: 10px;\"><a href=\"[SiteAdminUrl]/user/recover-password?[PasswordRecoveryToken]\" style=\"text-decoration: none;\"><div style=\"cursor: pointer; width: 200px; border-radius: 5px; background-color: #22707d; padding-left: 15px; padding-right: 15px; padding-top: 15px; padding-bottom: 15px; color: #ffffff; text-align: center; vertical-align: middle;\">Cambiar mi contraseña</div></a></td></tr><tr><td align=\"left\" style=\"padding-top:30px\"><b>¿No solicitaste este cambio?</b></td></tr><tr><td align=\"left\">Si no solicitaste la recuperación de tu contraseña sigue el siguiente enlace y háznoslo saber</td></tr><tr><td align=\"center\" style=\"padding-top: 10px;\"><a href=\"[SiteAdminUrl]/home?[PasswordRecoveryToken]\" style=\"text-decoration: none;\"><div style=\"width: 200px; border-radius: 5px; background-color: #CCCCCC; padding-left: 15px; padding-right: 15px; padding-top: 15px; padding-bottom: 15px; color: #333333; text-align: center; vertical-align: middle;\">Cancelar solicitud</div></a></td></tr><tr><td align=\"left\" style=\"padding-top: 30px;\">Equipo de Comunidad ParImpar.</td></tr></table></td></tr></table></body></html>";
            string token = "i=" + registerUser.Id + "&c=" + registerUser.CodeRecover;

            message = message.Replace("[FirstName]", registerUser.FirstName);
            message = message.Replace("[UserName]", registerUser.UserName);
            message = message.Replace("[SiteAdminUrl]", _configuration["GlobalVariables:Host"]);
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
                sendMailAsync(mailMessage);
                return new ApiResponse();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void sendMailAsync(MailMessage mailMessage)
        {
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587) { 
                UseDefaultCredentials = false,
                EnableSsl = true,
                DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network,
                Credentials = new System.Net.NetworkCredential("comunidadparimpar@gmail.com", "rtkdccokqveshpgc")
            };

            smtp.Send(mailMessage);
        }
    }
}
