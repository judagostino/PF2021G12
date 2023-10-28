
using System;

namespace ParImparApi.DTO
{
    public class ContactDTO
    {
        public int? Id { get; set; }

        public string Email { get; set; }

        public string UserName { get; set; }

        public string LastName { get; set; }

        public string FirstName { get; set; }

        public string Name { get; set; }

        public string ImageUrl { get; set; }

        public bool? Auditor { get; set; }

        public bool? Trusted { get; set; }

        public bool? Notifications { get; set; }

        public DateTime? DateBrirth { get; set; }

    }
}
