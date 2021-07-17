
namespace ParImparApi.DTO
{
    public class CredentialsLoginRequestDTO
    {
        public string User { get; set; }

        public string Password { get; set; }

        public bool KeepLoggedIn { get; set; }
    }
}
