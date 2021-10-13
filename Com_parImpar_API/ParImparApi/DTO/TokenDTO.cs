
using System;

namespace ParImparApi.DTO
{
    public class TokenDTO
    {
        public string ApplicationCode { get; set; }

        public string RefreshTokenId { get; set; }

        public string AccessTokenId { get; set; }

        public string RefreshTokenSignature { get; set; }

        public string AccessTokenSignature { get; set; }

        public string RefreshToken { get; set; }

        public string AccessToken { get; set; }

        public DateTime? RefreshTokenExpirationDate { get; set; }

        public DateTime? AccessTokenExpirationDate { get; set; }

        public string Claims { get; set; }

        public string ObjectKey { get; set; }

        public long? ObjectId { get; set; }

        public bool KeepLoggedIn { get; set; }

        public string IpAddress { get; set; }

        public string Client { get; set; }
    }
}
