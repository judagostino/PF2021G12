
using System;
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class SearchItemDTO
    {
        public int? Id { get; set; }

        public string Key { get; set; }

        public DateTime? StartDate { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public string ImageUrl { get; set; }

        public ContactDTO ContactCreate { get; set; }

        public List<TypeImpairmentDTO> TypeImpairment { get; set; }
    }
}
