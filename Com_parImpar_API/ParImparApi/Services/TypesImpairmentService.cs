using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class TypesImpairmentService
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IWebHostEnvironment _env;

        public TypesImpairmentService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IWebHostEnvironment env)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _env = env ?? throw new ArgumentNullException(nameof(env));
        }
        public async Task<ApiResponse> GetAll()
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("TypesImpairment_GetAll", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        await cnn.OpenAsync();

                        List<TypeImpairmentDTO> typesImpairment = new List<TypeImpairmentDTO>();
                        TypeImpairmentDTO type;

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = typesImpairment,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                type = new TypeImpairmentDTO();

                                if (reader["TypeId"] != DBNull.Value)
                                {
                                    type.Id = int.Parse(reader["TypeId"].ToString());
                                }
                                else
                                {
                                    type.Id = null;
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    type.Description = reader["Description"].ToString();
                                }

                                typesImpairment.Add(type);
                            }
                        }
                        #endregion


                        if (typesImpairment != null && typesImpairment.Count > 0)
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
