
namespace ParImparApi.DTO
{
    public class TokenResponseDTO
    {
        public string AccessToken { get; set; }
        
        public long? ExpiresIn { get; set; }

        public string RefreshToken { get; set; }

        public bool? KeepRefreshToken { get; set; }

    }
}
