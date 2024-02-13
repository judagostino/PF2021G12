
using System;
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class EventRequestDTO
    {
        public int? Id { get; set; }

        public DateTime? DateEntered { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public string ImageUrl { get; set; }

        public StateDTO State { get; set; }

        public ContactDTO ContactCreate { get; set; }

        public ContactDTO ContactAudit { get; set; }

        public bool? Assist { get; set; }

        public int? AttendeesCount { get; set; }

        public List<ContactDTO> contacts { get; set; }
    }
}
