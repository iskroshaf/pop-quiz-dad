using PopQuizApi.Models;
using System.Threading.Tasks;

namespace PopQuizApi.Services
{
    public class AuthService
    {
        public static async Task<bool> validateUser(HttpContext context)
        {
            MyDbContext dbContext = new MyDbContext();
            // Skip if endpoint has [AllowAnonymous]
          

            if (!context.Request.Headers.TryGetValue("token", out var token))
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync("Token is missing");
                return false;
            }

            var user = dbContext.Users.ToList().FirstOrDefault(u => u.RememberToken == token.ToString() && u.TokenExpiredAt > DateTime.Now);

            if (user == null)
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await context.Response.WriteAsync("Invalid or expired token");
              return false ;
            }

            // Extend token
            user.TokenExpiredAt = DateTime.Now.AddHours(12);
            await dbContext.SaveChangesAsync();

            // Attach user to context for later use in controller
            context.Items["User"] = user;

            return true;
        }
    }
}
