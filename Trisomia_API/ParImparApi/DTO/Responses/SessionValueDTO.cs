
namespace ParImparApi.DTO
{
    public class SessionValueDTO
    {
        public SessionValueDTO(string key, string value)
        {
            this.Key = key;
            this.Value = value;
        }

        public string Key { get; set; }
        
        public string Value { get; set; }
    }
}
