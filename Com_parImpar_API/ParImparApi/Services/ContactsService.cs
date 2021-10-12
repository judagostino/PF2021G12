using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class ContactsService
    {
        private readonly string _connectionString; 
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public ContactsService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> GetById(int? contactId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_GetById", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        if (contactId != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@ContactId", contactId));
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        }
                        #endregion

                        await cnn.OpenAsync();

                        ContactDTO contact = new ContactDTO();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = contact
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["ContactId"] != DBNull.Value)
                                {
                                    contact.Id = int.Parse(reader["ContactId"].ToString());
                                }
                                else
                                {
                                    contact.Id = null;
                                }

                                if (reader["FirstName"] != DBNull.Value)
                                {
                                    contact.FirstName = reader["FirstName"].ToString();
                                }

                                if (reader["LastName"] != DBNull.Value)
                                {
                                    contact.LastName = reader["LastName"].ToString();
                                }

                                if (reader["UserName"] != DBNull.Value)
                                {
                                    contact.UserName = reader["UserName"].ToString();
                                }

                                if (reader["Name"] != DBNull.Value)
                                {
                                    contact.Name = reader["Name"].ToString();
                                }

                                if (reader["email"] != DBNull.Value)
                                {
                                    contact.Email = reader["email"].ToString();
                                }

                                if (reader["email"] != DBNull.Value)
                                {
                                    contact.Email = reader["email"].ToString();
                                }

                                if (contactId == null && reader["Auditor"] != DBNull.Value)
                                {
                                    contact.Auditor = (bool)reader["Auditor"];
                                }

                                if (reader["DateBrirth"] != DBNull.Value)
                                {
                                    contact.DateBrirth = DateTime.Parse(reader["DateBrirth"].ToString());
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    contact.ImageUrl = reader["ImageUrl"].ToString();
                                }
                            }
                        }
                        #endregion


                        if (contact.Id != null && contact.Id > 0)
                        {
                            return new ApiResponse() {
                            Data = successResponse
                            };
                        }
                        else
                        {
                            return new ApiResponse()
                            {
                                Status = CustomStatusCodes.NotFound
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
