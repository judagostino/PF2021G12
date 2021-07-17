
using System.Collections.Generic;

namespace ParImparApi.DTO
{
    public class AccessTokenSettingsDTO
    {
        public string SigningKey { get; set; }

        public string Issuer { get; set; }

        public string Audience { get; set; }

        public int ExpirationTimeInSeconds { get; set; }
    }
}
