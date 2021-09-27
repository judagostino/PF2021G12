
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
        [Description("Field is required")] RequiredRequiredField = 5000,
        [Description("User name is required")] UserNameRequiredField = 5001,
        [Description("Password is required")] PasswordRequiredField = 5002,
        [Description("Email is required")] EmailRequiredField = 5003,
        [Description("Fisrt name is required")] FirstNameRequiredField = 5004,
        [Description("Last name is required")] LastNameRequiredField = 5005,
        [Description("Id is required")] RequiredId = 5006,
        [Description("Start date is required")] StartDateRequired = 5007,
        [Description("Title is required")] TitleRequired = 5008,
        [Description("New Password is required")] NewPasswordRequired = 5009,
        [Description("Confirm Password is required")] ConfirmPasswordRequired = 5010,

        
        // Item not exists
        [Description("Item not found")] ItemNotFound = 5100,

        // Item already exists
        [Description("Item already exists")] ItemAlreadyExists = 5200,

        // Other exceptions
        [Description("Expired token")] ExpiredToken = 5901,
        [Description("Invalid token")] InvalidToken = 5902,
        [Description("Unauthorized IP")] UnauthorizedIp = 5903,
        [Description("User-Agent is invalid")] UserAgentInvalid = 5905,
        [Description("Email exist")] EmailExist = 5906,
        [Description("Distint Emails")] DistintEmail = 5907,
        [Description("Distint passwords")] DistintPassword = 5908,
        [Description("Incorrect format password")] IncorretFormatPassword = 5909,
        [Description("unauthorized action ")] unauthorizedAction = 5910,
        [Description("Password not change")] NotChangePassword = 5911,
        [Description("Expired link")] ExpiredLink = 5912,
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