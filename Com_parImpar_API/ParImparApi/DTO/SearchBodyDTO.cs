
using System;
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class SearchBodyDTO
    {
        public string SearchText { get; set; }

        public List<TypeImpairmentDTO> Filters { get; set; }
    }
}
