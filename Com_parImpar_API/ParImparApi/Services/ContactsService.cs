using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using ParImparApi.Common;
using ParImparApi.DTO;
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class ContactsService
    {
        private readonly string _connectionString; 
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public ContactsService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<ApiResponse> RegistrerUser(RegisterUserDTO registerUser)
        {

            if (registerUser.Email != registerUser.ConfirmEmail)
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.DistintEmail
                };
            }

            if (registerUser.Password != registerUser.ConfirmPassword || !registerUser.Password.Equals(registerUser.ConfirmPassword))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.DistintPassword
                };
            }

            if (!validateFormatPassword(registerUser.Password))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.IncorretFormatPassword
                };
            }


            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_Regisrter", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@Email", registerUser.Email));
                        cmd.Parameters.Add(new SqlParameter("@UserName", registerUser.UserName));
                        cmd.Parameters.Add(new SqlParameter("@LastName", registerUser.LastName));
                        cmd.Parameters.Add(new SqlParameter("@FirstName ", registerUser.FirstName));
                        cmd.Parameters.Add(new SqlParameter("@Password", Crypto.EncryptGeneric(registerUser.Password, Constants.Encryption.Login.Key, Constants.Encryption.Login.Salt)));


                        if (registerUser.DateBrirth != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@DateBrirth", registerUser.DateBrirth));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@DateBrirth", DBNull.Value));
                        }

                        if (registerUser.Notifications != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@Notifications", registerUser.Notifications));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Notifications", DBNull.Value));
                        }

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ContactId",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ConfirmCode",
                            SqlDbType = System.Data.SqlDbType.VarChar,
                            Size = 100,
                            Direction = System.Data.ParameterDirection.Output
                        });
                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        if (cmd.Parameters["@ConfirmCode"].Value != DBNull.Value)
                        {
                            registerUser.ConfirmCode = cmd.Parameters["@ConfirmCode"].Value.ToString();
                        }

                        if (cmd.Parameters["@ContactId"].Value != DBNull.Value)
                        {
                            registerUser.Id = int.Parse(cmd.Parameters["@ContactId"].Value.ToString());
                        }

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

        public async Task<ApiResponse> RecoverPassword(RegisterUserDTO registerUser)
        {

            if (registerUser.Email != registerUser.ConfirmEmail)
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.DistintEmail
                };
            }

            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_RecoverPassword", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@Email", registerUser.Email));

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ContactId",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@CodeRecover",
                            SqlDbType = System.Data.SqlDbType.VarChar,
                            Size = 100,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@FirstName",
                            SqlDbType = System.Data.SqlDbType.VarChar,
                            Size = 100,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@UserName",
                            SqlDbType = System.Data.SqlDbType.VarChar,
                            Size = 100,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        if (cmd.Parameters["@ContactId"].Value != DBNull.Value)
                        {
                            registerUser.Id = int.Parse(cmd.Parameters["@ContactId"].Value.ToString());
                        }


                        if (cmd.Parameters["@CodeRecover"].Value != DBNull.Value)
                        {
                            registerUser.CodeRecover = cmd.Parameters["@CodeRecover"].Value.ToString();
                        }

                        if (cmd.Parameters["@UserName"].Value != DBNull.Value)
                        {
                            registerUser.UserName = cmd.Parameters["@UserName"].Value.ToString();
                        }

                        if (cmd.Parameters["@FirstName"].Value != DBNull.Value)
                        {
                            registerUser.FirstName = cmd.Parameters["@FirstName"].Value.ToString();
                        }

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

        public async Task<ApiResponse> Confirm(RegisterUserDTO registerUser)
        {

            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_Confirm", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", registerUser.Id));
                        cmd.Parameters.Add(new SqlParameter("@ConfirmCode", registerUser.ConfirmCode));


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

        public async Task<ApiResponse> DenyRecover(RegisterUserDTO registerUser)
        {

            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_Deny_Recover", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", registerUser.Id));
                        cmd.Parameters.Add(new SqlParameter("@CodeRecover", registerUser.CodeRecover));


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

        public async Task<ApiResponse> ValidarteRecover(RegisterUserDTO registerUser)
        {

            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_Validate_Recover", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", registerUser.Id));
                        cmd.Parameters.Add(new SqlParameter("@CodeRecover", registerUser.CodeRecover));


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

        public async Task<ApiResponse> RecoverChange(RegisterUserDTO registerUser)
        {

            if (registerUser.Password != registerUser.ConfirmPassword || !registerUser.Password.Equals(registerUser.ConfirmPassword))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.DistintPassword
                };
            }

            if (!validateFormatPassword(registerUser.Password))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.IncorretFormatPassword
                };
            }

            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_Change_Recover_Password", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", registerUser.Id));
                        cmd.Parameters.Add(new SqlParameter("@CodeRecover", registerUser.CodeRecover));
                        cmd.Parameters.Add(new SqlParameter("@Password", Crypto.EncryptGeneric(registerUser.Password, Constants.Encryption.Login.Key, Constants.Encryption.Login.Salt)));


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

        public async Task<ApiResponse> ChangePassword(ChangePasswordRequestDTO changePassword)
        {

            if (changePassword.NewPassword != changePassword.ConfirmPassword || !changePassword.NewPassword.Equals(changePassword.NewPassword))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.DistintPassword
                };
            }

            if (!validateFormatPassword(changePassword.NewPassword))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.IncorretFormatPassword
                };
            }

            if (changePassword.LastPassword == changePassword.NewPassword || changePassword.LastPassword.Equals(changePassword.NewPassword))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.NotChangePassword
                };
            }



            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_ChangePassword", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@LastPassword", Crypto.EncryptGeneric(changePassword.LastPassword, Constants.Encryption.Login.Key, Constants.Encryption.Login.Salt)));
                        cmd.Parameters.Add(new SqlParameter("@NewPassword", Crypto.EncryptGeneric(changePassword.NewPassword, Constants.Encryption.Login.Key, Constants.Encryption.Login.Salt)));


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

        public async Task<ApiResponse> GetById(int? contactId, int actionLog)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_GetById", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@ActionLog", actionLog));

                        #region [SP Parameters]
                        if (contactId != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@ContactId", contactId));
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        }
                        #endregion

                        await cnn.OpenAsync();

                        ContactDTO contact = new ContactDTO();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = contact
                        };

                        #region [BD fireld mapping]
                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                if (reader["ContactId"] != DBNull.Value)
                                {
                                    contact.Id = int.Parse(reader["ContactId"].ToString());
                                }
                                else
                                {
                                    contact.Id = null;
                                }

                                if (reader["FirstName"] != DBNull.Value)
                                {
                                    contact.FirstName = reader["FirstName"].ToString();
                                }

                                if (reader["LastName"] != DBNull.Value)
                                {
                                    contact.LastName = reader["LastName"].ToString();
                                }

                                if (reader["UserName"] != DBNull.Value)
                                {
                                    contact.UserName = reader["UserName"].ToString();
                                }

                                if (reader["Name"] != DBNull.Value)
                                {
                                    contact.Name = reader["Name"].ToString();
                                }

                                if (reader["Email"] != DBNull.Value)
                                {
                                    contact.Email = reader["Email"].ToString();
                                }

                                if (reader["Trusted"] != DBNull.Value)
                                {
                                    contact.Trusted = (bool)reader["Trusted"];
                                }

                                if (reader["Notifications"] != DBNull.Value)
                                {
                                    contact.Notifications = (bool)reader["Notifications"];
                                }

                                if (contactId == null && reader["Auditor"] != DBNull.Value)
                                {
                                    contact.Auditor = (bool)reader["Auditor"];
                                }

                                if (reader["DateBrirth"] != DBNull.Value)
                                {
                                    contact.DateBrirth = DateTime.Parse(reader["DateBrirth"].ToString());
                                }

                                if (reader["ImageUrl"] != DBNull.Value)
                                {
                                    contact.ImageUrl = reader["ImageUrl"].ToString();
                                }
                            }
                        }
                        #endregion


                        if (contact.Id != null && contact.Id > 0)
                        {
                            return new ApiResponse() {
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

        public async Task<ApiResponse> Update(ContactDTO contact)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("Contact_Update", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        #region [SP Parameters] 
                        cmd.Parameters.Add(new SqlParameter("@ContactId", int.Parse(await Functions.GetSessionValuesAsync(_httpContextAccessor.HttpContext, "ContactId"))));
                        cmd.Parameters.Add(new SqlParameter("@UserName", contact.UserName));
                        cmd.Parameters.Add(new SqlParameter("@LastName", contact.LastName));
                        cmd.Parameters.Add(new SqlParameter("@FirstName ", contact.FirstName));

                        if (contact.DateBrirth != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@DateBrirth", contact.DateBrirth));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@DateBrirth", DBNull.Value));
                        }

                        if (contact.Trusted != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@Trusted", contact.Trusted));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Trusted", DBNull.Value));
                        }

                        if (contact.Notifications != null)
                        {
                            cmd.Parameters.Add(new SqlParameter("@Notifications", contact.Notifications));

                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@Notifications", DBNull.Value));
                        }

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

        private bool validateFormatPassword(string password)
        {
            if (password.Trim().Length < 8)
            {
                return false;
            }

            bool existNumber = false;
            bool existCapitalLetter = false;
            bool existLowerLetter = false;

            foreach (char letter in password)
            {
                if (Char.IsDigit(letter))
                {
                    existNumber = true;
                    continue;
                }

                else if (letter.ToString() == letter.ToString().ToUpper())
                {
                    existCapitalLetter = true;
                    continue;
                }

                else if (letter.ToString() == letter.ToString().ToLower())
                {
                    existLowerLetter = true;
                    continue;
                }
            }

            if (existNumber && existCapitalLetter && existLowerLetter)
            {
                return true;
            }
            else
            {
                return false;
            }

        }
    }
}
