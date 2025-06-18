using System;
using System.Collections.Generic;

namespace PopQuizApi.Models;

public partial class User
{
    public long Id { get; set; }

    public string? Username { get; set; }

    public string? Password { get; set; }

    public string? Email { get; set; }

    public string? RememberToken { get; set; }

    public DateTime? TokenExpiredAt { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? DeletedAt { get; set; }

    public virtual ICollection<Game> Games { get; set; } = new List<Game>();
}
