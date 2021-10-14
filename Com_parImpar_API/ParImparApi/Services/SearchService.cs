using Microsoft.AspNetCore.Hosting;
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
    public class SearchService
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IWebHostEnvironment _env;

        public SearchService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IWebHostEnvironment env)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _env = env ?? throw new ArgumentNullException(nameof(env));
        }

        public async Task<ApiResponse> GetSearch(SearchBodyDTO searchBody)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Search_GetSearch", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        if (searchBody != null)
                        {
                            if (!string.IsNullOrWhiteSpace(searchBody.SearchText))
                            {
                                cmd.Parameters.Add(new SqlParameter("@SearchText", searchBody.SearchText));
                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter("@SearchText", DBNull.Value));
                            }

                            if (searchBody.Filters != null && searchBody.Filters.Count > 0)
                            {
                                string filtersAux = null;

                                for (int i = 0; i < searchBody.Filters.Count; i++)
                                {
                                    if (!string.IsNullOrWhiteSpace(filtersAux))
                                    {
                                        filtersAux = filtersAux + ",";
                                    }

                                    if (string.IsNullOrWhiteSpace(filtersAux))
                                    {
                                        filtersAux = searchBody.Filters[i].Id.ToString();
                                    } else
                                    {
                                        filtersAux = filtersAux + searchBody.Filters[i].Id.ToString();
                                    }
                                }
                                if (!string.IsNullOrWhiteSpace(filtersAux))
                                {
                                    cmd.Parameters.Add(new SqlParameter("@Filters", filtersAux));
                                } else
                                {
                                    cmd.Parameters.Add(new SqlParameter("@Filters", DBNull.Value));
                                }
                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter("@Filters", DBNull.Value));
                            }
                        } else {
                            cmd.Parameters.Add(new SqlParameter("@SearchText", DBNull.Value));
                            cmd.Parameters.Add(new SqlParameter("@Filters", DBNull.Value));
                        }
                        #endregion

                        await cnn.OpenAsync();

                        List<SearchItemDTO> results = new List<SearchItemDTO>();
                        SearchItemDTO item;

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = results,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                item = new SearchItemDTO();

                                if (reader["Id"] != DBNull.Value)
                                {
                                    item.Id = int.Parse(reader["Id"].ToString());
                                }
                                else
                                {
                                    item.Id = null;
                                }

                                if (reader["Key"] != DBNull.Value)
                                {
                                    item.Key = reader["Key"].ToString();
                                }

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    item.StartDate = DateTime.Parse(reader["StartDate"].ToString());
                                }

                                if (reader["Title"] != DBNull.Value)
                                {
                                    item.Title = reader["Title"].ToString();
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    item.ImageUrl = reader["ImageUrl"].ToString();
                                }

                                if (reader["Description"] != DBNull.Value)
                                {
                                    item.Description = reader["Description"].ToString();
                                }
                             
                                if (reader["ContacCreateId"] != DBNull.Value)
                                {
                                    item.ContactCreate = new ContactDTO()
                                    {
                                        Id = int.Parse(reader["ContacCreateId"].ToString()),
                                        Name = reader["NameCreate"].ToString()
                                    };
                                }

                                results.Add(item);
                            }
                        }
                        #endregion


                        if (results != null && results.Count > 0)
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
