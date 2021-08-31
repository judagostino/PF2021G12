
namespace ParImparApi.Common
{
    public class ApiErrorResponse
    {
        public ApiErrorResponse(int code, string message)
        {
            this.Code = code;
            this.Message = message;
        }

        public ApiErrorResponse(int code, string message, string traceId)
        {
            this.Code = code;
            this.Message = message;
            this.TraceId = traceId;
        }

        public int Code { get; set; }

        public string Message { get; set; }

        public string TraceId { get; set; }
    }
}
