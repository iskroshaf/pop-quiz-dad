using System;
using System.Collections.Generic;

namespace PopQuizApi.Models;

public partial class GameProgress
{
    public long Id { get; set; }

    public long? GametaskId { get; set; }

    public long? ParticipantId { get; set; }

    public string? SelectedAnswer { get; set; }

    public bool? Correct { get; set; }

    public DateTime? Datetime { get; set; }

    public virtual GameTask? Gametask { get; set; }

    public virtual Participant? Participant { get; set; }
}
