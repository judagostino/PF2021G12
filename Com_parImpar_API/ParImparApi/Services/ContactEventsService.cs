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
    public class ContactEventsService
    {
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public ContactEventsService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> GetAll()
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ContactXEvent_GetAll", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();

                        List<ContactXEventDTO> ContactXEvents = new List<ContactXEventDTO>();
                        ContactXEventDTO ContactEvent;

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = ContactXEvents,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["ContactEventId"] != DBNull.Value)
                                {
                                    ContactEvent = new ContactXEventDTO();

                                    if (reader["ContactEventId"] != DBNull.Value)
                                    {
                                        ContactEvent.Id = int.Parse(reader["ContactEventId"].ToString());
                                    }

                                    if (reader["EventId"] != DBNull.Value)
                                    {
                                        ContactEvent.EventId = int.Parse(reader["EventId"].ToString());
                                    }

                                    if (reader["DateEntered"] != DBNull.Value)
                                    {
                                        ContactEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                    }

                                    ContactXEvents.Add(ContactEvent);
                                }
                            }
                        }
                        #endregion


                        if (ContactXEvents != null && ContactXEvents.Count > 0)
                        {
                            return successResponse;
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

        public async Task<ApiResponse> GetById(int? eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ContactXEvent_GetById", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@EventId", eventId));
                        
                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();

                        ContactXEventDTO contactEvent = new ContactXEventDTO();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = contactEvent
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["ContactEventId"] != DBNull.Value)
                                {
                                    contactEvent.Id = int.Parse(reader["ContactEventId"].ToString());
                                }

                                if (reader["ContactId"] != DBNull.Value)
                                {
                                    contactEvent.ContactId = int.Parse(reader["ContactId"].ToString());
                                }

                                if (reader["EventId"] != DBNull.Value)
                                {
                                    contactEvent.EventId = int.Parse(reader["EventId"].ToString());
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    contactEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }
                            }
                        }
                        #endregion


                        if (contactEvent.Id != null && contactEvent.Id > 0)
                        {
                            return new ApiResponse()
                            {
                                Data = successResponse
                            };
                        }
                        else
                        {
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

        public async Task<ApiResponse> Insert(int? eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ContactXEvent_Insert", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters] 
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@EventId", eventId));

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });
                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        return new ApiResponse()
                        {
                            Status = (CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value
                        };
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

        public async Task<ApiResponse> Cancellation(int? eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ContactXEvent_Canllation", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters] 
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@EventId", eventId));

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });
                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        return new ApiResponse()
                        {
                            Status = (CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value
                        };
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
