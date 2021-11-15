using System;

namespace ParImparApi.Services
{
    public class UserActionLogDTO
    {
        public DateTime? DateEntered { get; set; }

        public string Description { get; set; }

        public string FiltersDescription { get; set; }

        public string SearchText { get; set; }

        public string ActionDone { get; set; }

        public string ContactAction { get; set; }
    }
}