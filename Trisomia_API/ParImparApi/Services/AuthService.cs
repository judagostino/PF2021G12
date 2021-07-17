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
    public class AuthService
    {
        private readonly string _connectionString; 
        private readonly TokensDbService _tokensDbService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public AuthService(TokensDbService tokensDbService, IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _tokensDbService = tokensDbService ?? throw new ArgumentNullException(nameof(tokensDbService));
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> CredentialsLogin(CredentialsLoginRequestDTO credentialsLoginRequest)
        {
            // Me fijo si el contacto tiene email y password en nuestra plataforma, entonces inicio sesión con sus credenciales, de lo contrario busco el LoginMethodCode
            LoginDataDTO loginData = await ValidateLocalCredentialsLogin(credentialsLoginRequest);

            if (loginData.ContactId != null && loginData.ContactId > 0)
            {
                // El contacto tiene usuario local en nuestra plataforma, ingresa por ahi
                return await LoginProcess(loginData, credentialsLoginRequest.KeepLoggedIn);
            }

            return new ApiResponse()
            {
                Status = CustomStatusCodes.Unauthorized
            };
        }

        public async Task<ApiResponse> Update(ChangeTokenRequestDTO changeToken)
        {

            // Desencripto el key del RefreshToken
            string key = await Functions.GetTokenClaimAsync(await Functions.GetTokenAsync(_httpContextAccessor.HttpContext, "RefreshAuth"), "key");
            string decryptedKey = Crypto.DecryptGeneric(key, Constants.Encryption.RefreshToken.Key, Constants.Encryption.RefreshToken.Salt);
            RefreshTokenKeyDTO refreshTokenKey = JsonConvert.DeserializeObject<RefreshTokenKeyDTO>(decryptedKey);

            // Valido el Client y la IP
            string client = _httpContextAccessor.HttpContext.Request.Headers["User-Agent"].ToString();
            string ipAddress = Functions.GetIPAddress(_httpContextAccessor.HttpContext).ToString();
            if (refreshTokenKey.Client != client)
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.UserAgentInvalid
                };
            }
            if (refreshTokenKey.IpAddress != ipAddress)
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.UnauthorizedIp
                };
            }

            // Valido si el RefreshToken esta activo en la BD
            TokenDTO oldToken = new TokenDTO()
            {
                RefreshTokenId = await Functions.GetTokenClaimAsync(await Functions.GetTokenAsync(_httpContextAccessor.HttpContext, "RefreshAuth"), JwtRegisteredClaimNames.Jti),
                RefreshTokenSignature = Functions.GetTokenSignature(await Functions.GetTokenAsync(_httpContextAccessor.HttpContext , "RefreshAuth")),
                AccessTokenId = await Functions.GetTokenClaimAsync(changeToken.Access, JwtRegisteredClaimNames.Jti),
                AccessTokenSignature = Functions.GetTokenSignature(changeToken.Access)
            };

            ApiResponse validateRegenerationResponse = await _tokensDbService.ValidateUpdate(oldToken);

            if (validateRegenerationResponse.Status == CustomStatusCodes.Success)
            {
                TokenResponseDTO authenticationResponse = new TokenResponseDTO();

                ApiSuccessResponse successResponse = new ApiSuccessResponse()
                {
                    Data = authenticationResponse
                };

                TokenDTO tokenDb = (TokenDTO)((ApiSuccessResponse)validateRegenerationResponse.Data).Data;

                string accessTokenId = Guid.NewGuid().ToString();
                string refreshTokenId = Guid.NewGuid().ToString();

                #region [AccessToken]
                List<Claim> claims = new List<Claim>();

                claims.Add(new Claim(JwtRegisteredClaimNames.Jti, accessTokenId));

                List<SessionValueDTO> sessionValues = JsonConvert.DeserializeObject<List<SessionValueDTO>>(tokenDb.Claims);
                if (sessionValues != null)
                {
                    foreach (SessionValueDTO sessionValue in sessionValues)
                    {
                        claims.Add(new Claim(sessionValue.Key, sessionValue.Value));
                    }
                }

                authenticationResponse.AccessToken = GenerateJWT(_configuration["AuthSettings:Default:AccessToken:SigningKey"], _configuration["AuthSettings:Default:AccessToken:Issuer"], _configuration["AuthSettings:Default:AccessToken:Audience"], long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"]), claims);
                authenticationResponse.ExpiresIn = long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"]);
                #endregion


                #region [RefreshToken]
                claims = new List<Claim>();

                claims.Add(new Claim(JwtRegisteredClaimNames.Jti, refreshTokenId));

                refreshTokenKey = new RefreshTokenKeyDTO()
                {
                    AccessTokenSignature = Functions.GetTokenSignature(authenticationResponse.AccessToken),
                    IpAddress = ipAddress,
                    Client = client
                };

                claims.Add(new Claim("key", Crypto.EncryptGeneric(JsonConvert.SerializeObject(refreshTokenKey), Constants.Encryption.RefreshToken.Key, Constants.Encryption.RefreshToken.Salt)));

                int refreshTokenExpirationTime;

                refreshTokenExpirationTime = int.Parse(_configuration["AuthSettings:Default:RefreshToken:ExpirationTimeInSeconds"]);
                authenticationResponse.KeepRefreshToken = true;

                authenticationResponse.RefreshToken = GenerateJWT(_configuration["AuthSettings:Default:RefreshToken:SigningKey"], _configuration["AuthSettings:Default:RefreshToken:Issuer"], _configuration["AuthSettings:Default:RefreshToken:Audience"], refreshTokenExpirationTime, claims);
                #endregion

                // Actualizo los tokens en la base
                TokenDTO newToken = new TokenDTO()
                {
                    RefreshTokenId = refreshTokenId,
                    AccessTokenId = accessTokenId,
                    RefreshTokenSignature = Functions.GetTokenSignature(authenticationResponse.RefreshToken),
                    AccessTokenSignature = Functions.GetTokenSignature(authenticationResponse.AccessToken),
                    RefreshToken = authenticationResponse.RefreshToken,
                    AccessToken = authenticationResponse.AccessToken,
                    RefreshTokenExpirationDate = DateTime.Now.AddSeconds(refreshTokenExpirationTime),
                    AccessTokenExpirationDate = DateTime.Now.AddSeconds(long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"])),
                    IpAddress = ipAddress
                };

                ApiResponse updateTokenResponse = await _tokensDbService.RegenerateToken(oldToken, newToken);

                if (updateTokenResponse.Status == CustomStatusCodes.Success)
                {
                    return new ApiResponse()
                    {
                        Data = successResponse
                    };
                }
                else
                {
                    return updateTokenResponse;
                }
            }
            else
            {
                return validateRegenerationResponse;
            }
        }

        private async Task<LoginDataDTO> ValidateLocalCredentialsLogin(CredentialsLoginRequestDTO credentialsLoginRequest)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_CredentialsLogin", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@Email", credentialsLoginRequest.User));
                        string a = Crypto.EncryptGeneric(credentialsLoginRequest.Password, Constants.Encryption.Login.Key, Constants.Encryption.Login.Salt);
                        cmd.Parameters.Add(new SqlParameter("@UserPassword", Crypto.EncryptGeneric(credentialsLoginRequest.Password, Constants.Encryption.Login.Key, Constants.Encryption.Login.Salt)));
                        #endregion

                        await cnn.OpenAsync();

                        LoginDataDTO loginData = new LoginDataDTO();
                

                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                loginData.ContactId = (int)reader["ContactId"];
                            }
                        }

                        return loginData;
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

        private async Task<ApiResponse> LoginProcess(LoginDataDTO loginData, bool keepLoggedIn)
        {
            // Genero el token
            return await GenerateTokenAsync(loginData, keepLoggedIn);
        }

        private Task<ApiResponse> GenerateTokenAsync(LoginDataDTO session, bool keepLoggedIn)
        {
            // Creo las variables de sesión
            List<SessionValueDTO> sessionValues = new List<SessionValueDTO>();

            foreach (PropertyInfo field in session.GetType().GetProperties())
            {
                if (field.GetValue(session) != null)
                {
                    sessionValues.Add(new SessionValueDTO(field.Name, field.GetValue(session).ToString()));
                }
            }


            //Genero el token de login
            return GetToken(sessionValues, keepLoggedIn);
        }

        private async Task<ApiResponse> GetToken(List<SessionValueDTO> sessionValues, bool keepLoggedIn)
        {

            TokenResponseDTO authenticationResponse = new TokenResponseDTO();

            ApiSuccessResponse successResponse = new ApiSuccessResponse()
            {
                Data = authenticationResponse
            };

            string accessTokenId = Guid.NewGuid().ToString();
            string refreshTokenId = Guid.NewGuid().ToString();

            #region [AccessToken]
            List<Claim> claims = new List<Claim>();

            claims.Add(new Claim(JwtRegisteredClaimNames.Jti, accessTokenId));

            if (sessionValues != null)
            {
                foreach (SessionValueDTO sessionValue in sessionValues)
                {
                    claims.Add(new Claim(sessionValue.Key, sessionValue.Value));
                }
            }

            authenticationResponse.AccessToken = GenerateJWT(_configuration["AuthSettings:Default:AccessToken:SigningKey"], _configuration["AuthSettings:Default:AccessToken:Issuer"], _configuration["AuthSettings:Default:AccessToken:Audience"], long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"]), claims);
            authenticationResponse.ExpiresIn = long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"]);
            #endregion


            #region [RefreshToken]
            claims = new List<Claim>();

            claims.Add(new Claim(JwtRegisteredClaimNames.Jti, refreshTokenId));

            RefreshTokenKeyDTO refreshTokenKey = new RefreshTokenKeyDTO()
            {
                AccessTokenSignature = Functions.GetTokenSignature(authenticationResponse.AccessToken),
                IpAddress = Functions.GetIPAddress(_httpContextAccessor.HttpContext).ToString(),
                Client = _httpContextAccessor.HttpContext.Request.Headers["User-Agent"].ToString()
            };

            claims.Add(new Claim("key", Crypto.EncryptGeneric(JsonConvert.SerializeObject(refreshTokenKey), Constants.Encryption.RefreshToken.Key, Constants.Encryption.RefreshToken.Salt)));

            int refreshTokenExpirationTime;

            refreshTokenExpirationTime = int.Parse(_configuration["AuthSettings:Default:RefreshToken:ExpirationTimeInSeconds"]);
            authenticationResponse.KeepRefreshToken = true;

            authenticationResponse.RefreshToken = GenerateJWT(_configuration["AuthSettings:Default:RefreshToken:SigningKey"], _configuration["AuthSettings:Default:RefreshToken:Issuer"], _configuration["AuthSettings:Default:RefreshToken:Audience"], refreshTokenExpirationTime, claims);

            #endregion

            // Guardo el token en la BD
            TokenDTO token = new TokenDTO()
            {
                RefreshTokenId = refreshTokenId,
                AccessTokenId = accessTokenId,
                RefreshTokenSignature = Functions.GetTokenSignature(authenticationResponse.RefreshToken),
                AccessTokenSignature = Functions.GetTokenSignature(authenticationResponse.AccessToken),
                RefreshToken = authenticationResponse.RefreshToken,
                AccessToken = authenticationResponse.AccessToken,
                RefreshTokenExpirationDate = DateTime.Now.AddSeconds(refreshTokenExpirationTime),
                AccessTokenExpirationDate = DateTime.Now.AddSeconds(long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"])),
                Claims = JsonConvert.SerializeObject(sessionValues),
                KeepLoggedIn = keepLoggedIn,
                Client = _httpContextAccessor.HttpContext.Request.Headers["User-Agent"].ToString(),
                IpAddress = Functions.GetIPAddress(_httpContextAccessor.HttpContext).ToString()
            };

            ApiResponse insertTokenResponse = await _tokensDbService.InsertToken(token);

            if (insertTokenResponse.Status == CustomStatusCodes.Success)
            {
                return new ApiResponse()
                {
                    Data = successResponse
                };
            }
            else
            {
                return insertTokenResponse;
            }
        }

        private async Task<ApiResponse> ChangeToken(List<SessionValueDTO> sessionValues, ChangeTokenRequestDTO changeTokenRequest)
        {

            // Valido si el AccessToken esta activo en la BD
            TokenDTO oldToken = new TokenDTO()
            {
                AccessTokenId = await Functions.GetTokenClaimAsync(changeTokenRequest.Access, JwtRegisteredClaimNames.Jti),
                AccessTokenSignature = Functions.GetTokenSignature(changeTokenRequest.Access)
            };

            ApiResponse validateChangeResponse = await _tokensDbService.ValidateChange(oldToken);

            if (validateChangeResponse.Status == CustomStatusCodes.Success)
            {
                oldToken = (TokenDTO)((ApiSuccessResponse)validateChangeResponse.Data).Data;

                TokenResponseDTO authenticationResponse = new TokenResponseDTO();

                ApiSuccessResponse successResponse = new ApiSuccessResponse()
                {
                    Data = authenticationResponse
                };

                string accessTokenId = Guid.NewGuid().ToString();
                string refreshTokenId = Guid.NewGuid().ToString();

                #region [AccessToken]
                List<Claim> claims = new List<Claim>();

                claims.Add(new Claim(JwtRegisteredClaimNames.Jti, accessTokenId));

                if (sessionValues != null)
                {
                    foreach (SessionValueDTO sessionValue in sessionValues)
                    {
                        claims.Add(new Claim(sessionValue.Key, sessionValue.Value));
                    }
                }

                authenticationResponse.AccessToken = GenerateJWT(_configuration["AuthSettings:Default:AccessToken:SigningKey"], _configuration["AuthSettings:Default:AccessToken:Issuer"], _configuration["AuthSettings:Default:AccessToken:Audience"], long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"]), claims);
                authenticationResponse.ExpiresIn = long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"]);
                #endregion


                #region [RefreshToken]
                claims = new List<Claim>();

                claims.Add(new Claim(JwtRegisteredClaimNames.Jti, refreshTokenId));

                RefreshTokenKeyDTO refreshTokenKey = new RefreshTokenKeyDTO()
                {
                    AccessTokenSignature = Functions.GetTokenSignature(authenticationResponse.AccessToken),
                    IpAddress = oldToken.IpAddress,
                    Client = oldToken.Client
                };

                claims.Add(new Claim("key", Crypto.EncryptGeneric(JsonConvert.SerializeObject(refreshTokenKey), Constants.Encryption.RefreshToken.Key, Constants.Encryption.RefreshToken.Salt)));

                int refreshTokenExpirationTime;

                refreshTokenExpirationTime = int.Parse(_configuration["AuthSettings:Default:RefreshToken:ExpirationTimeInSeconds"]);
                authenticationResponse.KeepRefreshToken = true;

                authenticationResponse.RefreshToken = GenerateJWT(_configuration["AuthSettings:Default:RefreshToken:SigningKey"], _configuration["AuthSettings:Default:RefreshToken:Issuer"], _configuration["AuthSettings:Default:RefreshToken:Audience"], refreshTokenExpirationTime, claims);

                #endregion

                // Guardo el token en la BD
                TokenDTO newToken = new TokenDTO()
                {
                    RefreshTokenId = refreshTokenId,
                    AccessTokenId = accessTokenId,
                    RefreshTokenSignature = Functions.GetTokenSignature(authenticationResponse.RefreshToken),
                    AccessTokenSignature = Functions.GetTokenSignature(authenticationResponse.AccessToken),
                    RefreshToken = authenticationResponse.RefreshToken,
                    AccessToken = authenticationResponse.AccessToken,
                    RefreshTokenExpirationDate = DateTime.Now.AddSeconds(refreshTokenExpirationTime),
                    AccessTokenExpirationDate = DateTime.Now.AddSeconds(long.Parse(_configuration["AuthSettings:Default:AccessToken:ExpirationTimeInSeconds"])),
                    Claims = JsonConvert.SerializeObject(sessionValues)
                };

                ApiResponse changeTokenResponse = await _tokensDbService.ChangeToken(oldToken, newToken);

                if (changeTokenResponse.Status == CustomStatusCodes.Success)
                {
                    return new ApiResponse()
                    {
                        Data = successResponse
                    };
                }
                else
                {
                    return changeTokenResponse;
                }
            }
            else
            {
                return validateChangeResponse;
            }
        }

        public string GenerateJWT(string encryptionKey, string issuer, string audience, long expirationTimeInSeconds, List<Claim> claims)
        {
            // Header
            var symmetricSecurityKey = new SymmetricSecurityKey(
                    Encoding.UTF8.GetBytes(encryptionKey)
                );
            var signingCredentials = new SigningCredentials(
                    symmetricSecurityKey, SecurityAlgorithms.HmacSha256
                );
            var header = new JwtHeader(signingCredentials);

            // Payload
            var payload = new JwtPayload(
                    issuer: issuer,
                    audience: audience,
                    claims: claims,
                    notBefore: DateTime.UtcNow,
                    expires: DateTime.UtcNow.AddSeconds(expirationTimeInSeconds)
                );

            // Generación del token
            var token = new JwtSecurityToken(
                    header,
                    payload
                );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
