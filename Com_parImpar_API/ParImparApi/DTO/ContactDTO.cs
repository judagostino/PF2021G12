
using System;
using System.Collections.Generic;
using System.Linq;

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

        public List<EventRequestDTO> Events { get; set; }

        public List<PostsDTO> Posts { get; set; }

        public static ContactDTO GetContactById(List<ContactDTO> contacts, int? id)
        {
            // Utilizar LINQ para encontrar el contacto con el ID proporcionado
            ContactDTO contact = contacts.FirstOrDefault(c => c.Id == id);

            return contact;
        }
    }
}
