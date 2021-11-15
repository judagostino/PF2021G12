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
    public class AuxiliarService
    {
        private readonly string _connectionString; 
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public AuxiliarService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> GetByKeyAndId(string key, int id)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("DenyObject_GetByKeyAndId", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ObjectId", id));
                        cmd.Parameters.Add(new SqlParameter("@ObjectKey", key));
                        #endregion

                        await cnn.OpenAsync();

                        DenyDTO deny = new DenyDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = deny,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["Reason"] != DBNull.Value)
                                {
                                    deny.Reason = reader["Reason"].ToString();
                                }
                            }
                        }
                        #endregion


                        if (deny != null && deny.Reason  != null && !string.IsNullOrEmpty(deny.Reason))
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

    }
}
