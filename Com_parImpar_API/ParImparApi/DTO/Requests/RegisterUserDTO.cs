
using System;

namespace ParImparApi.DTO
{
    public class RegisterUserDTO
    {
        public string Email { get; set; }

        public string ConfirmEmail { get; set; }

        public string UserName { get; set; }

        public string LastName { get; set; }

        public string FistName { get; set; }

        public string Password { get; set; }

        public string ConfirmPassword { get; set; }

        public DateTime? DateBrirth { get; set; }
    }
}
