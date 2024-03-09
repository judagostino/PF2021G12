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
    public class ActionLogService
    {
        private readonly string _connectionString; 
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public ActionLogService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> GetAll()
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("ActionLog_GetActions", cnn))
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

                        ActionsLogDTO actionLog = new ActionsLogDTO();
                        actionLog.EventViews = new List<ViewrsActionLogDTO>();
                        actionLog.GraphicImpediment = new List<GraphicImpedimentDTO>();
                        actionLog.PostViews = new List<ViewrsActionLogDTO>();
                        actionLog.ProfileViews = new List<ViewrsActionLogDTO>();
                        actionLog.UserActionLog = new List<UserActionLogDTO>();
                        actionLog.TypesActionLo = new List<TypesActionLogDTO>();

                        ViewrsActionLogDTO viewrsActionLog;
                        GraphicImpedimentDTO graphicImpediment;
                        UserActionLogDTO userActionLog;
                        TypesActionLogDTO typesActionLog;


                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = actionLog,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            /* acciones de usuario */
                            while (await reader.ReadAsync())
                            {
                                userActionLog = new UserActionLogDTO();

                                if (reader["DateEntered"] != DBNull.Value)
                                {
                                    userActionLog.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                }
                                else
                                {
                                    userActionLog.DateEntered = null;
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    userActionLog.Description = reader["Description"].ToString();
                                }


                                if (reader["FiltersDescription"] != DBNull.Value)
                                {
                                    userActionLog.FiltersDescription = reader["FiltersDescription"].ToString();
                                }

                                if (reader["SearchText"] != DBNull.Value)
                                {
                                    userActionLog.SearchText = reader["SearchText"].ToString();
                                }

                                if (reader["ActionDone"] != DBNull.Value)
                                {
                                    userActionLog.ActionDone = reader["ActionDone"].ToString();
                                }

                                if (reader["ContactAction"] != DBNull.Value)
                                {
                                    userActionLog.ContactAction = reader["ContactAction"].ToString();
                                }
                                
                                if (userActionLog.DateEntered != null)
                                {
                                    actionLog.UserActionLog.Add(userActionLog);
                                }

                            }

                            await reader.NextResultAsync();

                            /* Post mas vistos */
                            while (await reader.ReadAsync())
                            {
                                viewrsActionLog = new ViewrsActionLogDTO();

                                if (reader["ObjectKey"] != DBNull.Value && reader["ObjectKey"].ToString() == "PostId")
                                {
                                    if (reader["Viewrs"] != DBNull.Value)
                                    {
                                        viewrsActionLog.Viewrs = int.Parse(reader["Viewrs"].ToString());
                                    } else
                                    {
                                        viewrsActionLog.Viewrs = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        viewrsActionLog.Title = reader["Title"].ToString();
                                    }

                                    if (reader["name"] != DBNull.Value)
                                    {
                                        viewrsActionLog.name = reader["name"].ToString();
                                    }

                                    if (viewrsActionLog.Viewrs != null)
                                    {
                                        actionLog.PostViews.Add(viewrsActionLog);
                                    }

                                }
                            }

                            await reader.NextResultAsync();

                            /* Events mas vistos */
                            while (await reader.ReadAsync())
                            {
                                viewrsActionLog = new ViewrsActionLogDTO();

                                if (reader["ObjectKey"] != DBNull.Value && reader["ObjectKey"].ToString() == "EventId")
                                {
                                    if (reader["Viewrs"] != DBNull.Value)
                                    {
                                        viewrsActionLog.Viewrs = int.Parse(reader["Viewrs"].ToString());
                                    }
                                    else
                                    {
                                        viewrsActionLog.Viewrs = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        viewrsActionLog.Title = reader["Title"].ToString();
                                    }

                                    if (reader["name"] != DBNull.Value)
                                    {
                                        viewrsActionLog.name = reader["name"].ToString();
                                    }

                                    if (viewrsActionLog.Viewrs != null)
                                    {
                                        actionLog.EventViews.Add(viewrsActionLog);
                                    }

                                }
                            }

                            await reader.NextResultAsync();

                            /* Perfiles mas vistos */
                            while (await reader.ReadAsync())
                            {
                                viewrsActionLog = new ViewrsActionLogDTO();

                                if (reader["ObjectKey"] != DBNull.Value && reader["ObjectKey"].ToString() == "ContactId")
                                {
                                    if (reader["Viewrs"] != DBNull.Value)
                                    {
                                        viewrsActionLog.Viewrs = int.Parse(reader["Viewrs"].ToString());
                                    }
                                    else
                                    {
                                        viewrsActionLog.Viewrs = null;
                                    }

                                    if (reader["name"] != DBNull.Value)
                                    {
                                        viewrsActionLog.name = reader["name"].ToString();
                                    }

                                    if (viewrsActionLog.Viewrs != null)
                                    {
                                        actionLog.ProfileViews.Add(viewrsActionLog);
                                    }

                                }
                            }

                            await reader.NextResultAsync();

                            /* Perfiles mas vistos */
                            while (await reader.ReadAsync())
                            {
                                graphicImpediment = new GraphicImpedimentDTO();

                                if (reader["CountSearchs"] != DBNull.Value)
                                {
                                    graphicImpediment.countSearch = int.Parse(reader["CountSearchs"].ToString());
                                }
                                else
                                {
                                    graphicImpediment.countSearch = null;
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    graphicImpediment.Description = reader["Description"].ToString();
                                }

                                if (graphicImpediment.countSearch != null)
                                {
                                    actionLog.GraphicImpediment.Add(graphicImpediment);
                                }
                            }


                            await reader.NextResultAsync();

                            /* typos de Acciones */
                            while (await reader.ReadAsync())
                            {
                                typesActionLog = new TypesActionLogDTO();

                                if (reader["Description"] != DBNull.Value)
                                {
                                    typesActionLog.Description = reader["Description"].ToString();
                                }

                                actionLog.TypesActionLo.Add(typesActionLog);
                            }
                        }
                        #endregion


                        if ((CustomStatusCodes)(int)cmd.Parameters["@ResultCode"].Value == CustomStatusCodes.Success)
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
    }
}
