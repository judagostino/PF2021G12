using System.Collections.Generic;

namespace ParImparApi.Services
{
    public class ActionsLogDTO
    {
        public List<UserActionLogDTO> UserActionLog { get; set; }

        public List<ViewrsActionLogDTO> PostViews { get; set; }

        public List<ViewrsActionLogDTO> EventViews { get; set; }

        public List<ViewrsActionLogDTO> ProfileViews { get; set; }

        public List<GraphicImpedimentDTO> GraphicImpediment { get; set; }

    }
}