using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using ParImparApi.Common;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace ParImparApi.Services
{
    public class UploadService
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IWebHostEnvironment _env;

        public UploadService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IWebHostEnvironment env)
        {
            _configuration = configuration;
            _connectionString = configuration.GetConnectionString("defaultConnection");
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _env = env ?? throw new ArgumentNullException(nameof(env));
        }

       #region [Private methods]
        public async Task<ApiResponse> UploadImage(IFormCollection formCollection)
        {
            ApiResponse response;

            string uploadType = formCollection["Type"];
            string pathToSave = null;
            string key = "";
            string folderName = "";
            string imageName = "";
            string urlImage = _configuration["GlobalVariables:UrlImage"];

            if (string.IsNullOrEmpty(uploadType) == false)
            {
                switch (uploadType.ToLower())
                {
                    case "events":
                        {
                            key = "EventId";
                            folderName = "Events";
                            pathToSave = Path.Combine(_configuration["GlobalVariables:SaveImage"], folderName);
                            break;
                        }
                    case "posts":
                        {
                            key = "PostId";
                            folderName = "Posts";
                            pathToSave = Path.Combine(_configuration["GlobalVariables:SaveImage"], folderName);
                            break;
                        }
                    case "profile":
                        {
                            key = "ContactId";
                            folderName = "Profiles";
                            pathToSave = Path.Combine(_configuration["GlobalVariables:SaveImage"], folderName);
                            break;
                        }
                    default:
                        {
                            return new ApiResponse() {Status = CustomStatusCodes.BadRequest};
                        }
                }
                urlImage = urlImage + "/" + folderName;
            }
            
            var file = formCollection.Files.First();
            string id = formCollection["Id"];

            if (file.Length > 0 && pathToSave != null)
            {
               /* var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                string fullPath = Path.Combine(pathToSave, fileName);
                var dbPath = Path.Combine(folderName, fileName);
                using (var stream = new FileStream(fullPath, FileMode.Create))
                {
                    file.CopyTo(stream);
                }*/


                if (string.IsNullOrEmpty(id))
                {
                    return new ApiResponse()
                    {
                        Status = CustomStatusCodes.RequiredId
                    };
                }

                imageName = key + "_" + id;
                
                response = UploadFile(formCollection, pathToSave, imageName);

                if (response.Status != CustomStatusCodes.Success)
                {
                    return response;
                }

                urlImage = urlImage + "/" + ((UploadDTO)((ApiSuccessResponse)response.Data).Data).UniqueFileName;

                return await UpdateImage(key, int.Parse(id), urlImage.Trim());
            }
            else
            {
                return new ApiResponse() { Status = CustomStatusCodes.BadRequest }; ;
            }
        }


        public async Task<ApiResponse> UpdateImage(string objectKey, int objectId, string imageUrl)
        {
            using (SqlConnection cnn = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("object_UpdateImage", cnn))
                {
                    try
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@objectId", objectId));
                        cmd.Parameters.Add(new SqlParameter("@objectKey", objectKey));
                        cmd.Parameters.Add(new SqlParameter("@urlImage", imageUrl.Trim()));

                        #region [SP Parameters]
                        cmd.Parameters.Add(new SqlParameter()
                        {
                            ParameterName = "@ResultCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Direction = System.Data.ParameterDirection.Output
                        });

                        #endregion

                        await cnn.OpenAsync();
                        await cmd.ExecuteNonQueryAsync();

                        ApiSuccessResponse successResponse = new ApiSuccessResponse()
                        {
                            Data = imageUrl
                        };

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


        private ApiResponse UploadFile(IFormCollection formCollection, string pathToSave, string imageName)
        {
            var file = formCollection.Files.First();

            if (file.Length > 0)
            {
                string[] arrayName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"').Split(".");
                string type = arrayName[arrayName.Length - 1].Trim();

                imageName = imageName + "." + type;

                var fullPath = Path.Combine(pathToSave, imageName.Trim());
                File.Delete(fullPath.ToString());
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
                            UniqueFileName = imageName,
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
        #endregion
    }
}
