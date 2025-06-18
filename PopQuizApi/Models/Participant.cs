using System;
using System.Collections.Generic;

namespace PopQuizApi.Models;

public partial class Participant
{
    public long Id { get; set; }

    public string? ParticipantName { get; set; }

    public DateTime? JoinTime { get; set; }

    public string? Status { get; set; }

    public long? GameId { get; set; }

    public string? SessionId { get; set; }

    public virtual Game? Game { get; set; }

    public virtual ICollection<GameProgress> GameProgresses { get; set; } = new List<GameProgress>();

    public virtual ICollection<GameResult> GameResults { get; set; } = new List<GameResult>();
}
