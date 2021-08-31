using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class EventsService
    {
        private readonly string _connectionString; 
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public EventsService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> Insert(EventRequestDTO eventRequest)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_Insert", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactCreateId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));

                        if (eventRequest.StartDate != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@StartDate", eventRequest.StartDate));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@StartDate", DBNull.Value));
                        }

                        if (eventRequest.EndDate != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@EndDate", eventRequest.StartDate));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@EndDate", DBNull.Value));
                        }

                        if (eventRequest.Title != null && !string.IsNullOrWhiteSpace(eventRequest.Title))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", eventRequest.StartDate));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", DBNull.Value));
                        }
                        
                        if (eventRequest.Description != null && !string.IsNullOrWhiteSpace(eventRequest.Description))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", eventRequest.StartDate));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", DBNull.Value));
                        }


                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });
                        
                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@EventId",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();

                        EventRequestDTO newEvent = new EventRequestDTO();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = newEvent
                        };

                        #region [BD fireld mapping]
                        using ( var  reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader[""] != DBNull.Value)
                                {

                                }
                            }
                        }
                        #endregion


                            if (cmd.Parameters["@EventId"].Value != DBNull.Value
                            && (int)cmd.Parameters["@EventId"].Value > 0
                            && (CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value == CustomStatusCodes.Success)
                        {
                            eventRequest.Id = (int)cmd.Parameters["@EventId"].Value;
                            return new ApiResponse()
                            {
                                Status = CustomStatusCodes.Success,
                                Data = eventRequest
                            };
                        }
                        else 
                        {
                            return new ApiResponse()
                            {
                                Status = CustomStatusCodes.BadRequest
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

        public async Task<ApiResponse> Update(int eventId, EventRequestDTO eventRequest)
        {
            return new ApiResponse()
            {
                Status = CustomStatusCodes.Success
            };
        }

        public async Task<ApiResponse> Delete(int eventId)
        {
            return new ApiResponse()
            {
                Status = CustomStatusCodes.Success
            };
        }

        public async Task<ApiResponse> GetById(int eventId)
        {
            return new ApiResponse()
            {
                Status = CustomStatusCodes.Success
            };
        }

        public async Task<ApiResponse> GetAll()
        {
            return new ApiResponse()
            {
                Status = CustomStatusCodes.Success
            };
        }

        public async Task<ApiResponse> Autorize()
        {
            return new ApiResponse()
            {
                Status = CustomStatusCodes.Success
            };
        }

        public async Task<ApiResponse> Deny()
        {
            return new ApiResponse()
            {
                Status = CustomStatusCodes.Success
            };
        }
    }
}
