using System;
using System.Collections.Generic;

namespace ParImparApi.Services
{
    public class ContactTypeImplairmentDTO
    {
        public int? Id { get; set; }

        public int? ContactId { get; set; }

        public int? TypeId { get; set; }

        public List<int> Types { get; set; }

        public DateTime? DateEntered { get; set; }
    }
}