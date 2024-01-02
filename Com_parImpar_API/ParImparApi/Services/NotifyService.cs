using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class NotifyService
    {
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public NotifyService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> NewEventsAndPosts()
        {
            string notificationTokenConfigured = _configuration["AuthSettings:Default:InternalSecurity:Notificy"];

            string notificationTokenReceived = Functions.GetHeader(_httpContextAccessor.HttpContext, "Authorization");

            if (notificationTokenReceived != null && !notificationTokenReceived.Equals("") && notificationTokenReceived.ToLower().IndexOf("bearer") != -1)
            {
                string[] tokenSplit = notificationTokenReceived.Split(" ");
                if (tokenSplit.Length == 2 && tokenSplit[1] != notificationTokenConfigured) 
                {
                    return new ApiResponse()
                    {
                        Status = CustomStatusCodes.Unauthorized
                    };
                }
            }
            else {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.Unauthorized
                };
            }

            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Notify_NewEventsAndPosts", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();

                        List<ContactDTO> contacts = new List<ContactDTO>();
                        ContactDTO newContact;

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["ContactId"] != DBNull.Value && reader["FirstName"] != DBNull.Value)
                                {
                                    newContact = new ContactDTO();

                                    if (reader["ContactId"] != DBNull.Value)
                                    {
                                        newContact.Id = int.Parse(reader["ContactId"].ToString());
                                    }

                                    if (reader["FirstName"] != DBNull.Value)
                                    {
                                        newContact.FirstName = reader["FirstName"].ToString();
                                    }

                                    if (reader["Email"] != DBNull.Value)
                                    {
                                        newContact.Email = reader["Email"].ToString();
                                    }
                                    contacts.Add(newContact);
                                }
                            }
                            await reader.NextResultAsync();

                            ContactDTO contactEvent;

                            while (await reader.ReadAsync())
                            {

                                if (reader["EventId"] != DBNull.Value)
                                {
                              
                                    contactEvent = ContactDTO.GetContactById(contacts, int.Parse(reader["ContactId"].ToString()));
                                    EventRequestDTO eventRequest = new EventRequestDTO()
                                    {
                                        Id = int.Parse(reader["EventId"].ToString())
                                    };

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        eventRequest.Title = reader["Title"].ToString();
                                    }
                                    
                                    if (reader["EndDate"] != DBNull.Value)
                                    {
                                        eventRequest.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                    }

                                    if (reader["StartDate"] != DBNull.Value)
                                    {
                                        eventRequest.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                    }

                                    if (contactEvent.Events == null)
                                    {
                                        contactEvent.Events = new List<EventRequestDTO>();
                                        contactEvent.Events.Add(eventRequest);
                                    }
                                    else
                                    {
                                        contactEvent.Events.Add(eventRequest);
                                    }
                                }
                            }
                            await reader.NextResultAsync();

                            ContactDTO contactPost;
                            while (await reader.ReadAsync())
                            {
                                if (reader["PostId"] != DBNull.Value)
                                {

                                    contactPost = ContactDTO.GetContactById(contacts, int.Parse(reader["ContactId"].ToString()));
                                    PostsDTO post = new PostsDTO()
                                    {
                                        Id = int.Parse(reader["PostId"].ToString())
                                    };

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        post.Title = reader["Title"].ToString();
                                    }

                                    if (contactPost.Posts == null)
                                    {
                                        contactPost.Posts = new List<PostsDTO>();
                                        contactPost.Posts.Add(post);
                                    }
                                    else {
                                        contactPost.Posts.Add(post);
                                    }
                                }
                            }
                        }
                        #endregion

                        if ((CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value == CustomStatusCodes.Success)
                        {
                            // se envian Mails
                            return new ApiResponse()
                            {
                                Data = contacts,
                                Status = CustomStatusCodes.Success
                            };
                        }
                        else
                        {
                            // No se envia el mail
                            return new ApiResponse()
                            {
                                Status = (CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value
                            };
                        }

                    }
                    catch (Exception exc)
                    {
                        throw exc;
                    }
                    finally
                    {
                        if (cnn.State == System.Data.ConnectionState.Open)
                        {
                            await cnn.CloseAsync();
                        }
                    }
                }
            }
        }
    }
}
