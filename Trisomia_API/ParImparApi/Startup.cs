using System.Collections.Generic;
using System.IO;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using NLog;
using ParImparApi.NLog;
using ParImparApi.Services;

namespace ParImparApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            LogManager.LoadConfiguration(string.Concat(Directory.GetCurrentDirectory(), "/nlog.config"));
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddScoped<AuthService>(); 
            services.AddScoped<TokensDbService>();

            services.AddControllers();

            List<string> origins = new List<string>();

            foreach (var host in Configuration.GetSection("AllowedHosts").GetChildren())
            {
                origins.Add(host.Value);
            }


            services.AddCors(options =>
            {
                options.AddPolicy("AllowedOrigins",
                builder =>
                {
                    builder.WithOrigins(origins.ToArray())
                            .AllowAnyHeader()
                            .AllowAnyMethod();
                });
            });

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();

            services.AddSingleton<ILog, LogNLog>();

            services.AddMvc(options =>
            {
                options.EnableEndpointRouting = false;
            })
            .AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.IgnoreNullValues = true;
            })
            .SetCompatibilityVersion(CompatibilityVersion.Version_3_0);

            services.AddApiVersioning(config =>
            {
                config.ReportApiVersions = true;
            });


            // CONFIGURACI�N DEL SERVICIO DE AUTENTICACI�N JWT
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters()
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = Configuration["AuthSettings:Default:AccessToken:Issuer"],
                        ValidAudience = Configuration["AuthSettings:Default:AccessToken:Audience"],
                        IssuerSigningKey = new SymmetricSecurityKey(
                            Encoding.UTF8.GetBytes(Configuration["AuthSettings:Default:AccessToken:SigningKey"])
                        )
                    };
                })
                .AddJwtBearer("RefreshAuth",options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters()
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = Configuration["AuthSettings:Default:RefreshToken:Issuer"],
                        ValidAudience = Configuration["AuthSettings:Default:RefreshToken:Audience"],
                        IssuerSigningKey = new SymmetricSecurityKey(
                            Encoding.UTF8.GetBytes(Configuration["AuthSettings:Default:RefreshToken:SigningKey"])
                        )
                    };
                });


            services
                .AddAuthorization(options =>
                {
                    options.DefaultPolicy = new AuthorizationPolicyBuilder()
                        .RequireAuthenticatedUser()
                        .AddAuthenticationSchemes()
                        .Build();

                })
                .AddAuthorization(options =>
                {
                    options.AddPolicy("RefreshAuth", policy =>
                    {
                        policy.RequireAuthenticatedUser();
                        policy.AuthenticationSchemes.Add("RefreshAuth");
                    });
                });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors("AllowedOrigins");
            //app.UseCors();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });


        }
    }
}
