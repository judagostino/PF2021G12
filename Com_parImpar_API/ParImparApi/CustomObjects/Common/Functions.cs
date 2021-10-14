using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Newtonsoft.Json;

namespace ParImparApi.Common
{
    public static class Functions
    {
        public static async Task<IEnumerable<Claim>> GetTokenClaims(HttpContext context)
        {
            var token = await context.GetTokenAsync("access_token");
            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadToken(token) as JwtSecurityToken;

            return jwtToken.Claims;
        }

        public static async Task<string> GetTokenAsync(HttpContext context)
        {
            return await GetTokenAsync(context, null);
        }

        public static async Task<string> GetTokenAsync(HttpContext context, string scheme)
        {
            if (string.IsNullOrEmpty(scheme))
            {
                return await context.GetTokenAsync("access_token");
            }
            else
            {
                return await context.GetTokenAsync(scheme, "access_token");
            }
        }

        public static async Task<string> GetTokenClaimAsync(HttpContext context, string key)
        {
            return await GetTokenClaimAsync(context, null, key);
        }

        public static async Task<string> GetTokenClaimAsync(string token, string key)
        {
            return await GetTokenClaimAsync(null, token, key);
        }

        private static async Task<string> GetTokenClaimAsync(HttpContext context, string token, string key)
        {
            if(string.IsNullOrEmpty(token))
            {
                token = await context.GetTokenAsync("access_token");
            }

            if (token != null)
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadToken(token) as JwtSecurityToken;

                Claim claim = jwtToken.Claims.FirstOrDefault(claim => claim.Type == key);

                if (claim == null)
                {
                    return null;
                }
                else
                {
                    return claim.Value;
                }
            }
            else
            {
                throw new UnauthorizedAccessException("Token not exists");
            }
        }

        internal static object GenerateErrorResponse(HttpContext httpContext, object logger, CustomStatusCodes invalidType, object p)
        {
            throw new NotImplementedException();
        }

        public static string GetTokenSignature(string token)
        {
            return token.Substring(token.LastIndexOf(".") + 1);
        }

        public static string GetLanguage(HttpContext context)
        {
            string language = "";

            if (context.Request.Headers.TryGetValue("Accept-Language", out var lang))
            {
                language = lang.ToString().Split(";").FirstOrDefault()?.Split(",").FirstOrDefault();

                if (!string.IsNullOrEmpty(language) && language.Length > 2)
                {
                    language = language.Substring(0, 2);
                }
            }

            return language;
        }

        public static string GetHeader(HttpContext context, string name)
        {
            if (context.Request.Headers.TryGetValue(name, out var value))
            {
                return value;
            }

            return null;
        }

        public static IPAddress GetIPAddress(HttpContext context)
        {
            return context.Features.Get<IHttpConnectionFeature>()?.RemoteIpAddress;
        }

        public static string GetLogText(HttpContext context, string logText)
        {
            return GetLogText(context, logText, null, null);
        }

        public static string GetLogText(HttpContext context, Exception exc, object bodyParameter)
        {
            return GetLogText(context, null, exc, bodyParameter);
        }

        public static string GetLogText(HttpContext context, string logText, Exception exc, object bodyParameter)
        {
            string exception = "";
            string serializeBodyParameter = "";
            string headers = "";
            string apiVersion;
            string aux;

            if (exc != null)
            {
                exception = Environment.NewLine + "     Exception: " + exc.Message + Environment.NewLine + "     StackTrace: " + exc.StackTrace;
            }

            if (bodyParameter != null)
            {
                serializeBodyParameter = Environment.NewLine + "     Body: " + JsonConvert.SerializeObject(bodyParameter);
            }

            if (logText == null)
            {
                logText = "";
            }
            else
            {
                logText = Environment.NewLine + "     Message: " + logText;
            }

            #region [Headers]
            aux = GetHeader(context, "Authorization");
            headers = Environment.NewLine + "     Headers: Authorization=\"" + (string.IsNullOrEmpty(aux) ? "" : aux) + "\", ";

            aux = GetHeader(context, "X-api-version");
            apiVersion = (string.IsNullOrEmpty(aux) ? "" : aux);
            #endregion

            string result = context.TraceIdentifier + " - (" + context.Request.Method + ") " + GetAbsoluteUri(context).ToString() + " (ver: " + apiVersion + ") - " + context.Features.Get<IHttpConnectionFeature>()?.RemoteIpAddress.ToString()
                + logText
                + exception
                + headers
                + serializeBodyParameter;


            return result;
        }

        public static Uri GetAbsoluteUri(HttpContext context)
        {
            var request = context.Request;
            UriBuilder uriBuilder = new UriBuilder
            {
                Scheme = request.Scheme,
                Host = request.Host.Host,
                Path = request.Path.ToString(),
                Query = request.QueryString.ToString()
            };
            return uriBuilder.Uri;
        }

        public static ApiErrorResponse GenerateExceptionResponse(HttpContext context, NLog.ILog logger, Exception exception, object bodyParameter)
        {
            if (logger != null)
            {
                logger.Error(GetLogText(context, exception.Message, exception, bodyParameter));
            }

            return new ApiErrorResponse((int)CustomStatusCodes.InternalServerError, exception.Message, context.TraceIdentifier);
        }

        public static ApiErrorResponse GenerateErrorResponse(HttpContext context, NLog.ILog logger, CustomStatusCodes status, object bodyParameter)
        {
            return GenerateErrorResponse(context, logger, (int)status, status.ToDescription(), bodyParameter);
        }

        public static ApiErrorResponse GenerateErrorResponse(HttpContext context, NLog.ILog logger, int code, string message, object bodyParameter)
        {
            if (logger != null)
            {
                logger.Information(GetLogText(context, message, null, bodyParameter));
            }

            return new ApiErrorResponse(code, message, context.TraceIdentifier);
        }

        public static async Task<Dictionary<string, string>> GetSessionValuesAsync(HttpContext context, string[] keys)
        {
            return await GetSessionValuesAsync(context, null, keys);
        }

        public static async Task<string> GetSessionValuesAsync(HttpContext context, string key)
        {
            return await GetSessionValuesAsync(context, null, key);
        }


        public static async Task<string> GetSessionValuesAsync(HttpContext context, string scheme, string key)
        {
            Dictionary<string, string> values = new Dictionary<string, string>();

            var token = await GetTokenAsync(context, scheme);

            if (token != null)
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadToken(token) as JwtSecurityToken;

                Claim claim = jwtToken.Claims.FirstOrDefault(claim => claim.Type == key);

                if (claim == null)
                {
                    return null;
                }
                else
                {
                    return claim.Value;
                }
            }
            else
            {
                throw new UnauthorizedAccessException("Token not exists");
            }

            
        }

        public static async Task<Dictionary<string, string>> GetSessionValuesAsync(HttpContext context, string scheme, string[] keys)
        {
            Dictionary<string, string> values = new Dictionary<string, string>();

            var token = await GetTokenAsync(context, scheme);

            if (token != null)
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadToken(token) as JwtSecurityToken;

                foreach (string key in keys)
                {
                    Claim claim = jwtToken.Claims.FirstOrDefault(claim => claim.Type == key);

                    //if (claim == null)
                    //{
                    //    throw new UnauthorizedAccessException(key + " not exists");
                    //}
                    if (claim == null)
                    {
                        values.Add(key, null);
                    }
                    else
                    {
                        values.Add(key, claim.Value);
                    }
                }
            }
            else
            {
                return null;
            }

            return values;
        }

        public static async Task<Dictionary<string, string>> GetSessionValuesAsync(string token, string[] keys)
        {
            Dictionary<string, string> values = new Dictionary<string, string>();

            if (token != null)
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadToken(token) as JwtSecurityToken;

                foreach (string key in keys)
                {
                    Claim claim = jwtToken.Claims.FirstOrDefault(claim => claim.Type == key);

                    //if (claim == null)
                    //{
                    //    throw new UnauthorizedAccessException(key + " not exists");
                    //}
                    if (claim == null)
                    {
                        values.Add(key, null);
                    }
                    else
                    {
                        values.Add(key, claim.Value);
                    }
                }
            }
            else
            {
                return null;
            }

            return values;
        }
    }
}
