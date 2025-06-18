using System;
using System.Collections.Generic;

namespace PopQuizApi.Models;

public partial class GameTask
{
    public long Id { get; set; }

    public string? Question { get; set; }

    public string? OptionA { get; set; }

    public string? OptionB { get; set; }

    public string? OptionC { get; set; }

    public string? OptionD { get; set; }

    public string? Answer { get; set; }

    public long? GameId { get; set; }

    public long? QuestionNo { get; set; }

    public virtual Game? Game { get; set; }

    public virtual ICollection<GameProgress> GameProgresses { get; set; } = new List<GameProgress>();
}
