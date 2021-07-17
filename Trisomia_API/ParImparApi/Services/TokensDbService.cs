
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;

namespace ParImparApi.Services
{
    public class TokensDbService
    {
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public TokensDbService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> InsertToken(TokenDTO token)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_Insert", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenId", token.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenId", token.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignature", token.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignature", token.AccessTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshToken", token.RefreshToken));
                        cmd.Parameters.Add(new SqlParameter("@AccessToken", token.AccessToken));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenExpiratioNDate", token.RefreshTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenExpiratioNDate", token.AccessTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@Claims", token.Claims));
                        cmd.Parameters.Add(new SqlParameter("@KeepLoggedIn", token.KeepLoggedIn));
                        cmd.Parameters.Add(new SqlParameter("@IpAddress", token.IpAddress));
                        if (token.Client == null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@Client", DBNull.Value));
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Client", token.Client));
                        }

                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        return new ApiResponse()
                        {
                            Status = CustomStatusCodes.Success
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

        public async Task<ApiResponse> UpdateToken(TokenDTO oldToken, TokenDTO newToken)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_Update", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenIdOld", oldToken.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenIdOld", oldToken.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignatureOld", oldToken.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignatureOld", oldToken.AccessTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenId", newToken.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenId", newToken.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignature", newToken.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignature", newToken.AccessTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshToken", newToken.RefreshToken));
                        cmd.Parameters.Add(new SqlParameter("@AccessToken", newToken.AccessToken));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenExpiratioNDate", newToken.RefreshTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenExpiratioNDate", newToken.AccessTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@IpAddress", newToken.IpAddress));
                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        return new ApiResponse()
                        {
                            Status = CustomStatusCodes.Success
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

        public async Task<ApiResponse> RegenerateToken(TokenDTO oldToken, TokenDTO newToken)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_Regenerate", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenIdOld", oldToken.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignatureOld", oldToken.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenId", newToken.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenId", newToken.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignature", newToken.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignature", newToken.AccessTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshToken", newToken.RefreshToken));
                        cmd.Parameters.Add(new SqlParameter("@AccessToken", newToken.AccessToken));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenExpiratioNDate", newToken.RefreshTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenExpiratioNDate", newToken.AccessTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@IpAddress", newToken.IpAddress));
                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        return new ApiResponse()
                        {
                            Status = CustomStatusCodes.Success
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

        public async Task<ApiResponse> ChangeToken(TokenDTO oldToken, TokenDTO newToken)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_Change", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenIdOld", oldToken.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenIdOld", oldToken.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignatureOld", oldToken.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignatureOld", oldToken.AccessTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenId", newToken.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenId", newToken.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignature", newToken.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignature", newToken.AccessTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@RefreshToken", newToken.RefreshToken));
                        cmd.Parameters.Add(new SqlParameter("@AccessToken", newToken.AccessToken));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenExpiratioNDate", newToken.RefreshTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenExpiratioNDate", newToken.AccessTokenExpirationDate));
                        cmd.Parameters.Add(new SqlParameter("@Claims", newToken.Claims));
                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        return new ApiResponse()
                        {
                            Status = CustomStatusCodes.Success
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

        public async Task<ApiResponse> ValidateUpdate(TokenDTO token)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_ValidateUpdate", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenId", token.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenId", token.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignature", token.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignature", token.AccessTokenSignature));
                        #endregion

                        await cnn.OpenAsync();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = token
                        };

                        bool exists = false;

                        #region [BD field mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                exists = true;
                                if (reader["Claims"] != DBNull.Value)
                                {
                                    token.Claims = reader["Claims"].ToString();
                                }
                                if (reader["KeepLoggedIn"] != DBNull.Value)
                                {
                                    token.KeepLoggedIn = (bool)reader["KeepLoggedIn"];
                                }
                                if (reader["Client"] != DBNull.Value)
                                {
                                    token.Client = reader["Client"].ToString();
                                }
                            }
                        }
                        #endregion

                        if(exists)
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

        public async Task<ApiResponse> ValidateRegeneration(TokenDTO token, string ipAdress)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_ValidateRegeneration", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenId", token.RefreshTokenId));
                        cmd.Parameters.Add(new SqlParameter("@RefreshTokenSignature", token.RefreshTokenSignature));
                        cmd.Parameters.Add(new SqlParameter("@IpAddress", ipAdress));
                        #endregion

                        await cnn.OpenAsync();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = token
                        };

                        bool exists = false;

                        #region [BD field mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                exists = true;

                                if (reader["ObjectKey"] != DBNull.Value)
                                {
                                    token.ObjectKey = reader["ObjectKey"].ToString();
                                }
                                if (reader["ObjectId"] != DBNull.Value)
                                {
                                    token.ObjectId = (long)reader["ObjectId"];
                                }
                                if (reader["Claims"] != DBNull.Value)
                                {
                                    token.Claims = reader["Claims"].ToString();
                                }
                                if (reader["KeepLoggedIn"] != DBNull.Value)
                                {
                                    token.KeepLoggedIn = (bool)reader["KeepLoggedIn"];
                                }
                                if (reader["Client"] != DBNull.Value)
                                {
                                    token.Client = reader["Client"].ToString();
                                }
                            }
                        }
                        #endregion

                        if (exists)
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

        public async Task<ApiResponse> ValidateChange(TokenDTO token)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Tokens_ValidateChange", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenId", token.AccessTokenId));
                        cmd.Parameters.Add(new SqlParameter("@AccessTokenSignature", token.AccessTokenSignature));
                        #endregion

                        await cnn.OpenAsync();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = token
                        };

                        bool exists = false;

                        #region [BD field mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                exists = true;

                                if (reader["RefreshTokenId"] != DBNull.Value)
                                {
                                    token.RefreshTokenId = reader["RefreshTokenId"].ToString();
                                }
                                if (reader["RefreshTokenSignature"] != DBNull.Value)
                                {
                                    token.RefreshTokenSignature = reader["RefreshTokenSignature"].ToString();
                                }
                                if (reader["ObjectKey"] != DBNull.Value)
                                {
                                    token.ObjectKey = reader["ObjectKey"].ToString();
                                }
                                if (reader["ObjectId"] != DBNull.Value)
                                {
                                    token.ObjectId = (long)reader["ObjectId"];
                                }
                                if (reader["Claims"] != DBNull.Value)
                                {
                                    token.Claims = reader["Claims"].ToString();
                                }
                                if (reader["KeepLoggedIn"] != DBNull.Value)
                                {
                                    token.KeepLoggedIn = (bool)reader["KeepLoggedIn"];
                                }
                                if (reader["Client"] != DBNull.Value)
                                {
                                    token.Client = reader["Client"].ToString();
                                }
                                if (reader["IpAddress"] != DBNull.Value)
                                {
                                    token.IpAddress = reader["IpAddress"].ToString();
                                }
                            }
                        }
                        #endregion

                        if (exists)
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
