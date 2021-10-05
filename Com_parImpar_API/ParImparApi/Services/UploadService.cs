using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using ParImparApi.Common;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class UploadService
    {
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IWebHostEnvironment _env;

        public UploadService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IWebHostEnvironment env)
        {
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _env = env ?? throw new ArgumentNullException(nameof(env));
        }

       /* #region [Private methods]
        public async Task<ApiResponse> UploadChannelImage(IFormCollection formCollection)
        {
            //imageFolder = "channels";
            string id = formCollection["Id"];

            if (string.IsNullOrEmpty(id))
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.RequiredId
                };
            }


            var pathToSave = "";

            response = UploadFile(formCollection, pathToSave);

            if (response.Status != CustomStatusCodes.Success)
            {
                return response;
            }

            return await _channelsService.UpdateImage(int.Parse(id), (UploadDTO)((ApiSuccessResponse)response.Data).Data);
        }


        public async Task<ApiResponse> UpdateImage(string objectKey, int objectId, UploadDTO upload)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("bo_Channels_UpdateImage", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@objectId", objectId));
                        cmd.Parameters.Add(new SqlParameter("@objectKey", objectKey));

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = upload
                        };

                        #region [BD field mapping]

                        using (var reader = await cmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                upload.ImageUrl = reader["pathUrl"].ToString();
                            }
                        }
                        #endregion

                        return new ApiResponse()
                        {
                            Data = successResponse,
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


        private ApiResponse UploadFile(IFormCollection formCollection, string pathToSave)
        {
            var file = formCollection.Files.First();

            if (file.Length > 0)
            {
                string originalFileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                string uniqueFileName = Functions.GetUniqueId() + Path.GetExtension(originalFileName);
                string prefix = formCollection["Prefix"];
                if (string.IsNullOrEmpty(prefix) == false)
                {
                    if (prefix.Length > 50)
                    {
                        prefix = prefix.Substring(0, 50);
                    }

                    uniqueFileName = Functions.ToKebabCase(prefix) + "_" + uniqueFileName;
                }
                var fullPath = Path.Combine(pathToSave, uniqueFileName);
                using (var stream = new FileStream(fullPath, FileMode.Create))
                {
                    file.CopyTo(stream);
                }

                return new ApiResponse()
                {
                    Data = new ApiSuccessResponse()
                    {
                        Data = new UploadDTO()
                        {
                            OriginalFileName = originalFileName,
                            UniqueFileName = uniqueFileName,
                            Path = pathToSave
                        }
                    }
                };
            }
            else
            {
                return new ApiResponse()
                {
                    Status = CustomStatusCodes.FileIsEmpty
                };
            }
        }
        #endregion*/
    }
}
