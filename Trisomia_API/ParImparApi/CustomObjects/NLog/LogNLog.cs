using NLog;
using System;

namespace ParImparApi.NLog
{
    public class LogNLog : ILog
    {
        private static ILogger successLogger = LogManager.GetLogger("successLogger");
        private static ILogger errorLogger = LogManager.GetLogger("errorLogger");

        public LogNLog()
        {
        }

        public void Success(string message)
        {
            successLogger.Debug(message + Environment.NewLine);
        }

        public void Information(string message)
        {
            errorLogger.Info(message + Environment.NewLine);
        }

        public void Warning(string message)
        {
            errorLogger.Warn(message + Environment.NewLine);
        }

        public void Debug(string message)
        {
            errorLogger.Debug(message + Environment.NewLine);
        }

        public void Error(string message)
        {
            errorLogger.Error(message + Environment.NewLine);
        }
    }
}