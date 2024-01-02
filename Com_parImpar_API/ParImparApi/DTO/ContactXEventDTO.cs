using System;

namespace ParImparApi.Services
{
    public class ContactXEventDTO
    {
        public int? Id { get; set; }

        public int? ContactId { get; set; }

        public int? EventId { get; set; }

        public DateTime? DateEntered { get; set; }
    }
}