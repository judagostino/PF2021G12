
using System;
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class PostsDTO
    {
        public int? Id { get; set; }

        public DateTime? DateEntered { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public string Text { get; set; }

        public string ImageUrl { get; set; }

        public StateDTO State { get; set; }

        public ContactDTO ContactCreate { get; set; }

        public ContactDTO ContactAudit { get; set; }

        public List<TypeImpairmentDTO> TypeImpairment { get; set; }
    }
}
