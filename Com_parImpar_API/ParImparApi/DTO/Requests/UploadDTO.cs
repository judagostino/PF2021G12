namespace ParImparApi.Services
{
    public class UploadDTO
    {
        public string OriginalFileName { get; set; }

        public string UniqueFileName { get; set; }

        public string Path { get; set; }

        public string ImageUrl { get; set; }
    }
}