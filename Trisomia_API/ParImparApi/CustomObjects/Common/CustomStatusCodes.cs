
using System;
using System.ComponentModel;
using System.Reflection;

namespace ParImparApi.Common
{
    public enum CustomStatusCodes
    {
        Success = 200,
        BadRequest = 400,
        Unauthorized = 401,
        Forbidden = 403,
        NotFound = 404,
        [Description("Internal server error")] InternalServerError = 500,

        // Required fields
        [Description("Field is required")] RequiredField = 5000,

        // Item not exists
        [Description("Item not found")] ItemNotFound = 5100,

        // Item already exists
        [Description("Item already exists")] ItemAlreadyExists = 5200,

        // Other exceptions
        [Description("Expired token")] ExpiredToken = 5901,
        [Description("Invalid token")] InvalidToken = 5902,
        [Description("Unauthorized IP")] UnauthorizedIp = 5903,
        [Description("User-Agent is invalid")] UserAgentInvalid = 5905,
    }

    internal static class Extensions
    {
        public static string ToDescription(this Enum value)
        {
            FieldInfo field = value.GetType().GetField(value.ToString());
            DescriptionAttribute attribute = Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute)) as DescriptionAttribute;
            return attribute == null ? value.ToString() : attribute.Description;
        }
    }
}