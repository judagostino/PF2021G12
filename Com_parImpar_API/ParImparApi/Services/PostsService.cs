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
    public class PostsService
    {
        private readonly string _connectionString; 
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public PostsService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> Insert(PostsDTO posts)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_Insert", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactCreateId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));

                        if (posts.Text != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@Text", posts.Text));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@StartDate", DBNull.Value));
                        }

                        if (posts.Title != null && !string.IsNullOrWhiteSpace(posts.Title))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", posts.Title));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", DBNull.Value));
                        }

                        if (posts.Description != null && !string.IsNullOrWhiteSpace(posts.Description))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", posts.Description));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", DBNull.Value));
                        }

                        if (posts.TypeImpairment != null && posts.TypeImpairment.Count > 0)
                        {
                            string filtersAux = null;

                            for (int i = 0; i < posts.TypeImpairment.Count; i++)
                            {
                                if (!string.IsNullOrWhiteSpace(filtersAux))
                                {
                                    filtersAux = filtersAux + ",";
                                }

                                if (string.IsNullOrWhiteSpace(filtersAux))
                                {
                                    filtersAux = posts.TypeImpairment[i].Id.ToString();
                                }
                                else
                                {
                                    filtersAux = filtersAux + posts.TypeImpairment[i].Id.ToString();
                                }
                            }
                            if (!string.IsNullOrWhiteSpace(filtersAux))
                            {
                                cmd.Parameters.Add(new SqlParameter("@Types", filtersAux));
                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter("@Types", DBNull.Value));
                            }
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Types", DBNull.Value));
                        }


                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });
                        #endregion

                        await cnn.OpenAsync();

                        PostsDTO newPost = new PostsDTO();
                        TypeImpairmentDTO typeImpairment = new TypeImpairmentDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newPost,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (newPost.Id == null)
                                {
                                    if (reader["PostId"] != DBNull.Value)
                                    {
                                        newPost.Id = int.Parse(reader["PostId"].ToString());
                                    }
                                    else
                                    {
                                        newPost.Id = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        newPost.Title = reader["Title"].ToString();
                                    }

                                    if (reader["Text"] != DBNull.Value)
                                    {
                                        newPost.Text = reader["Text"].ToString();
                                    }

                                    if (reader["ImageUrl"] != DBNull.Value)
                                    {
                                        newPost.ImageUrl = reader["ImageUrl"].ToString();
                                    }

                                    if (reader["Description"] != DBNull.Value)
                                    {
                                        newPost.Description = reader["Description"].ToString();
                                    }

                                    if (reader["DateEntered"] != DBNull.Value)
                                    {
                                        newPost.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                    }

                                    if (reader["ContacCreate"] != DBNull.Value)
                                    {
                                        newPost.ContactCreate = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContacCreate"].ToString()),
                                            Name = reader["NameCreate"].ToString()
                                        };
                                    }


                                    if (reader["ContactAudit"] != DBNull.Value)
                                    {
                                        newPost.ContactAudit = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContactAudit"].ToString()),
                                            Name = reader["NameAudit"].ToString()
                                        };
                                    }

                                    if (reader["StateId"] != DBNull.Value)
                                    {
                                        newPost.State = new StateDTO()
                                        {
                                            Id = int.Parse(reader["StateId"].ToString()),
                                            Description = reader["DescriptionState"].ToString()
                                        };
                                    }

                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment.Id = int.Parse(reader["TypeId"].ToString());
                                        typeImpairment.Description = reader["DescriptionTypeImpairment"].ToString();
                                        newPost.TypeImpairment = new List<TypeImpairmentDTO>();
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }
                               
                                }
                                else
                                {
                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment = new TypeImpairmentDTO()
                                        {
                                            Id = int.Parse(reader["TypeId"].ToString()),
                                            Description = reader["DescriptionTypeImpairment"].ToString()
                                        };
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }
                                }

                            }
                        }
                        #endregion


                        if (newPost != null && newPost.Id > 0
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

        public async Task<ApiResponse> Update(int postId, PostsDTO posts)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_Update", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@PostId", postId));

                        if (posts.Text != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@Text", posts.Text));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@StartDate", DBNull.Value));
                        }

                        if (posts.Title != null && !string.IsNullOrWhiteSpace(posts.Title))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", posts.Title));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Title", DBNull.Value));
                        }

                        if (posts.Description != null && !string.IsNullOrWhiteSpace(posts.Description))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", posts.Description));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Description", DBNull.Value));
                        }

                        if (posts.TypeImpairment != null && posts.TypeImpairment.Count > 0)
                        {
                            string filtersAux = null;

                            for (int i = 0; i < posts.TypeImpairment.Count; i++)
                            {
                                if (!string.IsNullOrWhiteSpace(filtersAux))
                                {
                                    filtersAux = filtersAux + ",";
                                }

                                if (string.IsNullOrWhiteSpace(filtersAux))
                                {
                                    filtersAux = posts.TypeImpairment[i].Id.ToString();
                                }
                                else
                                {
                                    filtersAux = filtersAux + posts.TypeImpairment[i].Id.ToString();
                                }
                            }
                            if (!string.IsNullOrWhiteSpace(filtersAux))
                            {
                                cmd.Parameters.Add(new SqlParameter("@Types", filtersAux));
                            }
                            else
                            {
                                cmd.Parameters.Add(new SqlParameter("@Types", DBNull.Value));
                            }
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Types", DBNull.Value));
                        }


                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });
                        #endregion

                        await cnn.OpenAsync();

                        PostsDTO newPost = new PostsDTO();
                        TypeImpairmentDTO typeImpairment = new TypeImpairmentDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newPost,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (newPost.Id == null)
                                {
                                    if (reader["PostId"] != DBNull.Value)
                                    {
                                        newPost.Id = int.Parse(reader["PostId"].ToString());
                                    }
                                    else
                                    {
                                        newPost.Id = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        newPost.Title = reader["Title"].ToString();
                                    }

                                    if (reader["Text"] != DBNull.Value)
                                    {
                                        newPost.Text = reader["Text"].ToString();
                                    }

                                    if (reader["ImageUrl"] != DBNull.Value)
                                    {
                                        newPost.ImageUrl = reader["ImageUrl"].ToString();
                                    }

                                    if (reader["Description"] != DBNull.Value)
                                    {
                                        newPost.Description = reader["Description"].ToString();
                                    }

                                    if (reader["DateEntered"] != DBNull.Value)
                                    {
                                        newPost.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                    }

                                    if (reader["ContacCreate"] != DBNull.Value)
                                    {
                                        newPost.ContactCreate = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContacCreate"].ToString()),
                                            Name = reader["NameCreate"].ToString()
                                        };
                                    }


                                    if (reader["ContactAudit"] != DBNull.Value)
                                    {
                                        newPost.ContactAudit = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContactAudit"].ToString()),
                                            Name = reader["NameAudit"].ToString()
                                        };
                                    }

                                    if (reader["StateId"] != DBNull.Value)
                                    {
                                        newPost.State = new StateDTO()
                                        {
                                            Id = int.Parse(reader["StateId"].ToString()),
                                            Description = reader["DescriptionState"].ToString()
                                        };
                                    }

                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment.Id = int.Parse(reader["TypeId"].ToString());
                                        typeImpairment.Description = reader["DescriptionTypeImpairment"].ToString();
                                        newPost.TypeImpairment = new List<TypeImpairmentDTO>();
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }

                                }
                                else
                                {
                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment = new TypeImpairmentDTO()
                                        {
                                            Id = int.Parse(reader["TypeId"].ToString()),
                                            Description = reader["DescriptionTypeImpairment"].ToString()
                                        };
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }
                                }

                            }
                        }
                        #endregion


                        if (newPost != null && newPost.Id > 0
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

        public async Task<ApiResponse> Delete(int postId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_Delete", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@PostId", postId));

                      
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

        public async Task<ApiResponse> GetById(int postId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_GetById", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@PostId", postId));
                        #endregion

                        await cnn.OpenAsync();

                        PostsDTO newPost = new PostsDTO();
                        TypeImpairmentDTO typeImpairment = new TypeImpairmentDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newPost,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (newPost.Id == null)
                                {
                                    if (reader["PostId"] != DBNull.Value)
                                    {
                                        newPost.Id = int.Parse(reader["PostId"].ToString());
                                    }
                                    else
                                    {
                                        newPost.Id = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        newPost.Title = reader["Title"].ToString();
                                    }

                                    if (reader["Text"] != DBNull.Value)
                                    {
                                        newPost.Text = reader["Text"].ToString();
                                    }

                                    if (reader["ImageUrl"] != DBNull.Value)
                                    {
                                        newPost.ImageUrl = reader["ImageUrl"].ToString();
                                    }

                                    if (reader["Description"] != DBNull.Value)
                                    {
                                        newPost.Description = reader["Description"].ToString();
                                    }

                                    if (reader["DateEntered"] != DBNull.Value)
                                    {
                                        newPost.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                    }

                                    if (reader["ContacCreate"] != DBNull.Value)
                                    {
                                        newPost.ContactCreate = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContacCreate"].ToString()),
                                            Name = reader["NameCreate"].ToString()
                                        };
                                    }


                                    if (reader["ContactAudit"] != DBNull.Value)
                                    {
                                        newPost.ContactAudit = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContactAudit"].ToString()),
                                            Name = reader["NameAudit"].ToString()
                                        };
                                    }

                                    if (reader["StateId"] != DBNull.Value)
                                    {
                                        newPost.State = new StateDTO()
                                        {
                                            Id = int.Parse(reader["StateId"].ToString()),
                                            Description = reader["DescriptionState"].ToString()
                                        };
                                    }

                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment.Id = int.Parse(reader["TypeId"].ToString());
                                        typeImpairment.Description = reader["DescriptionTypeImpairment"].ToString();
                                        newPost.TypeImpairment = new List<TypeImpairmentDTO>();
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }

                                }
                                else
                                {
                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment = new TypeImpairmentDTO()
                                        {
                                            Id = int.Parse(reader["TypeId"].ToString()),
                                            Description = reader["DescriptionTypeImpairment"].ToString()
                                        };
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }
                                }

                            }
                        }
                        #endregion


                        if (newPost != null && newPost.Id > 0)
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

        public async Task<ApiResponse> GetByIdMoreInfo(int postId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_GetByIdMoreInfo", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@PostId", postId));
                        #endregion

                        await cnn.OpenAsync();

                        PostsDTO newPost = new PostsDTO();
                        TypeImpairmentDTO typeImpairment = new TypeImpairmentDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = newPost,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (newPost.Id == null)
                                {
                                    if (reader["PostId"] != DBNull.Value)
                                    {
                                        newPost.Id = int.Parse(reader["PostId"].ToString());
                                    }
                                    else
                                    {
                                        newPost.Id = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        newPost.Title = reader["Title"].ToString();
                                    }

                                    if (reader["Text"] != DBNull.Value)
                                    {
                                        newPost.Text = reader["Text"].ToString();
                                    }

                                    if (reader["ImageUrl"] != DBNull.Value)
                                    {
                                        newPost.ImageUrl = reader["ImageUrl"].ToString();
                                    }

                                    if (reader["Description"] != DBNull.Value)
                                    {
                                        newPost.Description = reader["Description"].ToString();
                                    }

                                    if (reader["DateEntered"] != DBNull.Value)
                                    {
                                        newPost.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                    }

                                    if (reader["ContacCreate"] != DBNull.Value)
                                    {
                                        newPost.ContactCreate = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContacCreate"].ToString()),
                                            Name = reader["NameCreate"].ToString()
                                        };
                                    }


                                    if (reader["ContactAudit"] != DBNull.Value)
                                    {
                                        newPost.ContactAudit = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContactAudit"].ToString()),
                                            Name = reader["NameAudit"].ToString()
                                        };
                                    }

                                    if (reader["StateId"] != DBNull.Value)
                                    {
                                        newPost.State = new StateDTO()
                                        {
                                            Id = int.Parse(reader["StateId"].ToString()),
                                            Description = reader["DescriptionState"].ToString()
                                        };
                                    }

                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment.Id = int.Parse(reader["TypeId"].ToString());
                                        typeImpairment.Description = reader["DescriptionTypeImpairment"].ToString();
                                        newPost.TypeImpairment = new List<TypeImpairmentDTO>();
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }

                                }
                                else
                                {
                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment = new TypeImpairmentDTO()
                                        {
                                            Id = int.Parse(reader["TypeId"].ToString()),
                                            Description = reader["DescriptionTypeImpairment"].ToString()
                                        };
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }
                                }

                            }
                        }
                        #endregion


                        if (newPost != null && newPost.Id > 0)
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

        public async Task<ApiResponse> GetAll(int? valideAuditor)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_GetAll", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));

                        if (valideAuditor != null && valideAuditor == 1)
                        {
                            cmd.Parameters.Add(new SqlParameter("@audit", 1));
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@audit", 0));
                        }
                        #endregion

                        await cnn.OpenAsync();

                        List<PostsDTO> posts = new List<PostsDTO>();
                        PostsDTO newPost = new PostsDTO() { 
                            Id = 0
                        };
                        TypeImpairmentDTO typeImpairment = new TypeImpairmentDTO();

                        ApiResponse successResponse = new ApiResponse()
                        {
                            Data = posts,
                            Status = CustomStatusCodes.Success
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["PostId"] != DBNull.Value && newPost.Id != int.Parse(reader["PostId"].ToString()))
                                {
                                    newPost = new PostsDTO();

                                    if (reader["PostId"] != DBNull.Value)
                                    {
                                        newPost.Id = int.Parse(reader["PostId"].ToString());
                                    }
                                    else
                                    {
                                        newPost.Id = null;
                                    }

                                    if (reader["Title"] != DBNull.Value)
                                    {
                                        newPost.Title = reader["Title"].ToString();
                                    }

                                    if (reader["Text"] != DBNull.Value)
                                    {
                                        newPost.Text = reader["Text"].ToString();
                                    }

                                    if (reader["ImageUrl"] != DBNull.Value)
                                    {
                                        newPost.ImageUrl = reader["ImageUrl"].ToString();
                                    }

                                    if (reader["Description"] != DBNull.Value)
                                    {
                                        newPost.Description = reader["Description"].ToString();
                                    }

                                    if (reader["DateEntered"] != DBNull.Value)
                                    {
                                        newPost.DateEntered = DateTime.Parse(reader["DateEntered"].ToString());
                                    }

                                    if (reader["ContacCreate"] != DBNull.Value)
                                    {
                                        newPost.ContactCreate = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContacCreate"].ToString()),
                                            Name = reader["NameCreate"].ToString()
                                        };
                                    }


                                    if (reader["ContactAudit"] != DBNull.Value)
                                    {
                                        newPost.ContactAudit = new ContactDTO()
                                        {
                                            Id = int.Parse(reader["ContactAudit"].ToString()),
                                            Name = reader["NameAudit"].ToString()
                                        };
                                    }

                                    if (reader["StateId"] != DBNull.Value)
                                    {
                                        newPost.State = new StateDTO()
                                        {
                                            Id = int.Parse(reader["StateId"].ToString()),
                                            Description = reader["DescriptionState"].ToString()
                                        };
                                    }

                                    if (reader["TypeId"] != DBNull.Value)
                                    {
                                        typeImpairment = new TypeImpairmentDTO()
                                        {
                                            Id = int.Parse(reader["TypeId"].ToString()),
                                            Description = reader["DescriptionTypeImpairment"].ToString()
                                        };
                                        newPost.TypeImpairment = new List<TypeImpairmentDTO>();
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }

                                    posts.Add(newPost);
                                }

                                else if(reader["PostId"] != DBNull.Value && newPost.Id == int.Parse(reader["PostId"].ToString()))
                                {
                                    if (reader["TypeId"] != DBNull.Value && typeImpairment.Id != int.Parse(reader["TypeId"].ToString()))
                                    {
                                        typeImpairment = new TypeImpairmentDTO()
                                        {
                                            Id = int.Parse(reader["TypeId"].ToString()),
                                            Description = reader["DescriptionTypeImpairment"].ToString()
                                        };
                                        newPost.TypeImpairment.Add(typeImpairment);
                                    }
                                }
                            }
                        }
                        #endregion


                        if (posts != null && posts.Count > 0)
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

        public async Task<ApiResponse> Autorize(int postId)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_Authorize", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@PostId", postId));


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

        public async Task<ApiResponse> Deny(int postId, string reason)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Posts_Deny", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@PostId", postId));

                        if (reason != null && !string.IsNullOrWhiteSpace(reason))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Reason", reason));
                        } else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Reason", DBNull.Value));
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
