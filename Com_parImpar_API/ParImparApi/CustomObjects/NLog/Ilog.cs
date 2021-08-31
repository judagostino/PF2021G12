namespace ParImparApi.NLog
{
    public interface ILog
    {
        void Success(string message);

        void Information(string message);

        void Warning(string message);

        void Debug(string message);

        void Error(string message);
    }
}