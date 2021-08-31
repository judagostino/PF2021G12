
namespace ParImparApi.Common
{
    public class ApiResponse
    {
        public ApiResponse()
        {
            this.Status = CustomStatusCodes.Success;
        }

        public ApiResponse(CustomStatusCodes status)
        {
            this.Status = status;
        }

        public object Data { get; set; }

        public CustomStatusCodes Status { get; set; }
    }
}
