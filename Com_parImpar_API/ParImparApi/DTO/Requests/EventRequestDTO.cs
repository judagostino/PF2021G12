
using System;

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

        public StateDTO State { get; set; }

        public ContactDTO ContactCreate { get; set; }

        public ContactDTO ContactAudit { get; set; }
    }
}
