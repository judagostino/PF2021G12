
namespace ParImparApi.DTO
{
    public class ChangePasswordRequestDTO
    {
        public string LastPassword { get; set; }

        public string NewPassword { get; set; }

        public string ConfirmPassword { get; set; }

    }
}
