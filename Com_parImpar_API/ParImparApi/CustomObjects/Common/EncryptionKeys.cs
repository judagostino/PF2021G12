using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ParImparApi.Common
{
    public class EncryptionKeys
    {
        public EncryptionKeys(string key, string salt)
        {
            this.Key = key;
            this.Salt = salt;
        }

        public string Key { get; set; }
        public string Salt { get; set; }
    }
}
