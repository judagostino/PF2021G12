
using System;

namespace ParImparApi.DTO
{
    public class RegisterUserDTO
    {
        public int? Id { get; set; }

        public string Email { get; set; }

        public string ConfirmEmail { get; set; }

        public string UserName { get; set; }

        public string LastName { get; set; }

        public string FirstName { get; set; }

        public string Password { get; set; }

        public string ConfirmPassword { get; set; }

        public string ConfirmCode { get; set; }

        public bool? Notifications { get; set; }

        public string CodeRecover { get; set; }

        public DateTime? DateBrirth { get; set; }
    }
}
