
using System;
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class SearchBodyDTO
    {
        public string SearchText { get; set; }

        public List<TypeImpairmentDTO> Filters { get; set; }

        public bool? events { get; set; }

        public bool? posts { get; set; }

    }
}
