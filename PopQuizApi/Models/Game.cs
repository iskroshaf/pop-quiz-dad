using System;
using System.Collections.Generic;

namespace PopQuizApi.Models;

public partial class Game
{
    public long Id { get; set; }

    public long? UserId { get; set; }

    public string? Title { get; set; }

    public DateTime? StartTime { get; set; }

    public DateTime? EndTime { get; set; }

    public bool? Status { get; set; }

    public string? Description { get; set; }

    public string? UniqueId { get; set; }

    public string? DomainUrl { get; set; }

    public virtual ICollection<GameTask> GameTasks { get; set; } = new List<GameTask>();

    public virtual ICollection<Participant> Participants { get; set; } = new List<Participant>();

    public virtual User? User { get; set; }
}
