
namespace ParImparApi.Common
{
    public static class Constants
    {
        public static class Encryption
        {
            public static readonly EncryptionKeys Login = new EncryptionKeys("vadftr43tdf!", "w342vd3r21!");
            public static readonly EncryptionKeys ConfirmRegistrationToken = new EncryptionKeys("DASE23ESDA1ZXzx", "w342vd3r21!");
            public static readonly EncryptionKeys PasswordRecoveryToken = new EncryptionKeys("dfserwwdcwe3234!", "w342vd3r21!");
            public static readonly EncryptionKeys RefreshToken = new EncryptionKeys("dsitfhojwerfj!", "w342vd3r21!");
        }
    }
}
