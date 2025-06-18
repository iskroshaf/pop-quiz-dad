using System.Security.Cryptography;
using System.Text;

namespace PopQuizApi.Models
{
    public partial class User
    {
        public void encryptPassword()
        {
            var sha = SHA256.Create();

            var bytes = Encoding.UTF8.GetBytes(Username + Password);

            var encrypt = sha.ComputeHash(bytes);

            var result = string.Join("", encrypt.Select(x => x.ToString("x2")));

            Password = result;
        }
    }
}
