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
                            cmd.Parameters.Add(new SqlParameter("@EndDate", eventRequest.EndDate));

                        }
                        else
                        {
                            if (eventRequest.StartDate != null)
                            {
                                cmd.Parameters.Add(new SqlParameter("@EndDate", eventRequest.StartDate));

                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter("@EndDate", DBNull.Value));
                            }
                        }

                        if (eventRequest.Title != null && !string.IsNullOrWhiteSpace(eventRequest.Title))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", eventRequest.Title));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", DBNull.Value));
                        }

                        if (eventRequest.Description != null && !string.IsNullOrWhiteSpace(eventRequest.Description))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", eventRequest.Description));

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
                        #endregion

                        await cnn.OpenAsync();

                        EventRequestDTO newEvent = new EventRequestDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newEvent,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using ( var  reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["EventId"] != DBNull.Value)
                                {
                                    newEvent.Id = int.Parse(reader["EventId"].ToString());
                                }
                                else
                                {
                                    newEvent.Id = null;
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    newEvent.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    newEvent.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    newEvent.Title = reader["Title"].ToString();
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    newEvent.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    newEvent.Description = reader["Description"].ToString();
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    newEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }

                                if (reader["ContacCreate"] != DBNull.Value)
                                {
                                    newEvent.ContactCreate = new ContactDTO() { 
                                        Id = int.Parse(reader["ContacCreate"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }


                                if (reader["ContactAudit"] != DBNull.Value)
                                {
                                    newEvent.ContactAudit = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContactAudit"].ToString()),
                                        Name = reader["NameAudit"].ToString()
                                    };
                                }

                                if (reader["StateId"] != DBNull.Value)
                                {
                                    newEvent.State = new StateDTO()
                                    {
                                        Id = int.Parse(reader["StateId"].ToString()),
                                        Description = reader["DescriptionState"].ToString()
                                    };
                                }
                            }
                        }
                        #endregion


                        if (newEvent != null && newEvent.Id > 0
                             && (CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value == CustomStatusCodes.Success)
                        {
                            return successResponse;
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

        public async Task<ApiResponse> Update(int eventId, EventRequestDTO eventRequest)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_Update", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@EventId", eventId));

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
                            cmd.Parameters.Add(new SqlParameter("@EndDate", eventRequest.EndDate));

                        }
                        else
                        {
                            if (eventRequest.StartDate != null)
                            {
                                cmd.Parameters.Add(new SqlParameter("@EndDate", eventRequest.StartDate));

                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter("@EndDate", DBNull.Value));
                            }
                        }

                        if (eventRequest.Title != null && !string.IsNullOrWhiteSpace(eventRequest.Title))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", eventRequest.Title));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", DBNull.Value));
                        }

                        if (eventRequest.Description != null && !string.IsNullOrWhiteSpace(eventRequest.Description))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", eventRequest.Description));

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
                        #endregion

                        await cnn.OpenAsync();

                        EventRequestDTO newEvent = new EventRequestDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newEvent,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["EventId"] != DBNull.Value)
                                {
                                    newEvent.Id = int.Parse(reader["EventId"].ToString());
                                } 
                                else
                                {
                                    newEvent.Id = null;
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    newEvent.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    newEvent.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    newEvent.Title = reader["Title"].ToString();
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    newEvent.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    newEvent.Description = reader["Description"].ToString();
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    newEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }

                                if (reader["ContacCreate"] != DBNull.Value)
                                {
                                    newEvent.ContactCreate = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContacCreate"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }


                                if (reader["ContactAudit"] != DBNull.Value)
                                {
                                    newEvent.ContactAudit = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContactAudit"].ToString()),
                                        Name = reader["NameAudit"].ToString()
                                    };
                                }

                                if (reader["StateId"] != DBNull.Value)
                                {
                                    newEvent.State = new StateDTO()
                                    {
                                        Id = int.Parse(reader["StateId"].ToString()),
                                        Description = reader["DescriptionState"].ToString()
                                    };
                                }
                            }
                        }
                        #endregion


                        if (newEvent != null && newEvent.Id > 0
                            && (CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value == CustomStatusCodes.Success)
                        {
                            return successResponse;
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

        public async Task<ApiResponse> Delete(int eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_Delete", cnn))
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

        public async Task<ApiResponse> GetById(int eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_GetById", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@EventId", eventId));
                        #endregion

                        await cnn.OpenAsync();

                        EventRequestDTO newEvent = new EventRequestDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newEvent,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["EventId"] != DBNull.Value)
                                {
                                    newEvent.Id = int.Parse(reader["EventId"].ToString());
                                }
                                else
                                {
                                    newEvent.Id = null;
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    newEvent.Title = reader["Title"].ToString();
                                }
                                
                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    newEvent.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    newEvent.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    newEvent.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    newEvent.Description = reader["Description"].ToString();
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    newEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }

                                if (reader["ContacCreate"] != DBNull.Value)
                                {
                                    newEvent.ContactCreate = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContacCreate"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }


                                if (reader["ContactAudit"] != DBNull.Value)
                                {
                                    newEvent.ContactAudit = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContactAudit"].ToString()),
                                        Name = reader["NameAudit"].ToString()
                                    };
                                }

                                if (reader["StateId"] != DBNull.Value)
                                {
                                    newEvent.State = new StateDTO()
                                    {
                                        Id = int.Parse(reader["StateId"].ToString()),
                                        Description = reader["DescriptionState"].ToString()
                                    };
                                }
                            }
                        }
                        #endregion


                        if (newEvent.Id != null && newEvent.Id > 0)
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

        public async Task<ApiResponse> GetByIdMoreInfo(int eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_GetByIdMoreInfo", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@EventId", eventId));
                        #endregion

                        await cnn.OpenAsync();

                        EventRequestDTO newEvent = new EventRequestDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newEvent,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["EventId"] != DBNull.Value)
                                {
                                    newEvent.Id = int.Parse(reader["EventId"].ToString());
                                }
                                else
                                {
                                    newEvent.Id = null;
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    newEvent.Title = reader["Title"].ToString();
                                }
                                
                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    newEvent.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    newEvent.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    newEvent.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    newEvent.Description = reader["Description"].ToString();
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    newEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }

                                if (reader["ContacCreate"] != DBNull.Value)
                                {
                                    newEvent.ContactCreate = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContacCreate"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }

                                if (reader["ContactAudit"] != DBNull.Value)
                                {
                                    newEvent.ContactAudit = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContactAudit"].ToString()),
                                        Name = reader["NameAudit"].ToString()
                                    };
                                }

                                if (reader["StateId"] != DBNull.Value)
                                {
                                    newEvent.State = new StateDTO()
                                    {
                                        Id = int.Parse(reader["StateId"].ToString()),
                                        Description = reader["DescriptionState"].ToString()
                                    };
                                }
                            }
                        }
                        #endregion


                        if (newEvent.Id != null && newEvent.Id > 0)
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

        public async Task<ApiResponse> GetAll()
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_GetAll", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        #endregion

                        await cnn.OpenAsync();

                        List<EventRequestDTO> events = new List<EventRequestDTO>();
                        EventRequestDTO newEvent;

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = events,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                newEvent = new EventRequestDTO();

                                if (reader["EventId"] != DBNull.Value)
                                {
                                    newEvent.Id = int.Parse(reader["EventId"].ToString());
                                }
                                else
                                {
                                    newEvent.Id = null;
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    newEvent.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    newEvent.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    newEvent.Title = reader["Title"].ToString();
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    newEvent.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    newEvent.Description = reader["Description"].ToString();
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    newEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }

                                if (reader["ContacCreate"] != DBNull.Value)
                                {
                                    newEvent.ContactCreate = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContacCreate"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }


                                if (reader["ContactAudit"] != DBNull.Value)
                                {
                                    newEvent.ContactAudit = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContactAudit"].ToString()),
                                        Name = reader["NameAudit"].ToString()
                                    };
                                }

                                if (reader["StateId"] != DBNull.Value)
                                {
                                    newEvent.State = new StateDTO()
                                    {
                                        Id = int.Parse(reader["StateId"].ToString()),
                                        Description = reader["DescriptionState"].ToString()
                                    };
                                }

                                events.Add(newEvent);
                            }
                        }
                        #endregion


                        if (events != null && events.Count > 0)
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

        public async Task<ApiResponse> GetByDate(DateTime date)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_GetByDate", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@Date", date));
                        #endregion

                        await cnn.OpenAsync();

                        List<EventRequestDTO> events = new List<EventRequestDTO>();
                        EventRequestDTO newEvent;

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = events,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                newEvent = new EventRequestDTO();

                                if (reader["EventId"] != DBNull.Value)
                                {
                                    newEvent.Id = int.Parse(reader["EventId"].ToString());
                                }
                                else
                                {
                                    newEvent.Id = null;
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    newEvent.EndDate = DateTime.Parse(reader["EndDate"].ToString());
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    newEvent.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    newEvent.Title = reader["Title"].ToString();
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    newEvent.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    newEvent.Description = reader["Description"].ToString();
                                }

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    newEvent.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }

                                if (reader["ContacCreate"] != DBNull.Value)
                                {
                                    newEvent.ContactCreate = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContacCreate"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }

                                events.Add(newEvent);
                            }
                        }
                        #endregion


                        if (events != null && events.Count > 0)
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

        public async Task<ApiResponse> Autorize(int eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_Authorize", cnn))
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

                        EventRequestDTO newEvent = new EventRequestDTO();

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

        public async Task<ApiResponse> Deny(int eventId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Events_Deny", cnn))
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

                        EventRequestDTO newEvent = new EventRequestDTO();

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
