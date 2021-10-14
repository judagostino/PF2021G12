// =============================================
// Author:			Mariano Giorda
// Create date:		30/06/2020 10:14:20
// =============================================

using ParImparApi.Common;
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class LoginDTO
    {
        public string accessToken { get; set; }
        
        public long? expiresIn { get; set; }

        public string refreshToken { get; set; }

        public bool? keepRefreshToken { get; set; }

        public string reAuthenticationToken { get; set; }
    }
}
