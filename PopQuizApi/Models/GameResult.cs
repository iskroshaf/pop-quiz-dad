using System;
using System.Collections.Generic;

namespace PopQuizApi.Models;

public partial class GameResult
{
    public long Id { get; set; }

    public long? ParticipantId { get; set; }

    public string? Result { get; set; }

    public DateTime? Datetime { get; set; }

    public bool? Status { get; set; }

    public long? Ranking { get; set; }

    public virtual Participant? Participant { get; set; }
}
