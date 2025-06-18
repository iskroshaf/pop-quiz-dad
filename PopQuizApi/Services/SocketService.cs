using Azure.Core;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using PopQuizApi.Models;
using System.Net.WebSockets;
using System.Text;
using System.Threading.Tasks;

namespace PopQuizApi.Services
{
    public class SocketService
    {
        public static readonly Dictionary<string, List<WebSocket>> GameSockets = new();

        public static async Task sendUpdate(Game game)
        {
            if (!GameSockets.ContainsKey(game.UniqueId))
                return ;

            var sockets = GameSockets[game.UniqueId];

            MyDbContext context = new();

            var participants = context.Participants.Where(x => x.GameId == game.Id).Include(x => x.GameProgresses).ToList();
            var message = participants.Select(x => new
            {
                x.ParticipantName,
                Progress = x.GameProgresses.Count,
                CorrectCount = x.GameProgresses.Count(x => x.Correct == true),
                Accuracy = x.GameProgresses.Any()
                            ? (double)x.GameProgresses.Count(x => x.Correct == true) / x.GameProgresses.Count :
                            0,
                time = x.GameProgresses.Any(x=>x.Datetime != null) ? (x.GameProgresses.Max(x => x.Datetime) - x.GameProgresses.Min(x => x.Datetime)).Value.TotalSeconds : int.MaxValue

            }).OrderByDescending(x => x.CorrectCount).ThenByDescending(x => x.Accuracy).ThenBy(x => x.time).ToList();

            var buffer = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(message));
            var segment = new ArraySegment<byte>(buffer);

            foreach (var socket in sockets.ToList())
            {
                if (socket.State == WebSocketState.Open)
                {
                    await socket.SendAsync(segment, WebSocketMessageType.Text, true, CancellationToken.None);
                }
            }
        }
    }
}
