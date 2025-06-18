using Microsoft.EntityFrameworkCore;
using PopQuizApi.Models;

namespace PopQuizApi.Middlewares
{
    public class AuthMiddleware :IMiddleware
    {
        private readonly RequestDelegate _next;

        public AuthMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            MyDbContext dbContext = new MyDbContext();
            // Skip if endpoint has [AllowAnonymous]
            var endpoint = context.GetEndpoint();
            var allowAnonymous = endpoint?.Metadata?.GetMetadata<Microsoft.AspNetCore.Authorization.AllowAnonymousAttribute>() != null;
            if (allowAnonymous)
            {
                await _next(context);
                return;
            }

            if (!context.Request.Headers.TryGetValue("token", out var token))
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync("Token is missing");
                return;
            }

            var user = dbContext.Users.FirstOrDefault(u => u.RememberToken == token && u.TokenExpiredAt > DateTime.Now);

            if (user == null)
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync("Invalid or expired token");
                return;
            }

            // Extend token
            user.TokenExpiredAt = DateTime.Now.AddHours(12);
            await dbContext.SaveChangesAsync();

            // Attach user to context for later use in controller
            context.Items["User"] = user;

            await _next(context);
        }

        public async Task InvokeAsync  (HttpContext context, RequestDelegate next)
        {
            // Skip if endpoint has [AllowAnonymous]

            MyDbContext dbContext = new MyDbContext();
            var endpoint = context.GetEndpoint();
            var allowAnonymous = endpoint?.Metadata?.GetMetadata<Microsoft.AspNetCore.Authorization.AllowAnonymousAttribute>() != null;
            if (allowAnonymous)
            {
                await _next(context);
                return;
            }

            if (!context.Request.Headers.TryGetValue("token", out var token))
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync("Token is missing");
                return;
            }

            var user = dbContext.Users.FirstOrDefault(u => u.RememberToken == token && u.TokenExpiredAt > DateTime.Now);

            if (user == null)
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync("Invalid or expired token");
                return;
            }

            // Extend token
            user.TokenExpiredAt = DateTime.Now.AddHours(12);
            await dbContext.SaveChangesAsync();

            // Attach user to context for later use in controller
            context.Items["User"] = user;

            await _next(context);
        }
    }
}
