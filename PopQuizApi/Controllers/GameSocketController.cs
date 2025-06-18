namespace PopQuizApi.Controllers
{
    using System.Net.WebSockets;
    using System.Text;

    public static class GameSocketController
    {
        public static async Task ProcessWebSocket(
     WebSocket socket,
     string gameId,
     Dictionary<string, List<WebSocket>> gameSockets)
        {
            var buffer = new byte[8 * 1024];

            while (socket.State == WebSocketState.Open)
            {
                var segment = new ArraySegment<byte>(buffer);
                var result = await socket.ReceiveAsync(segment, CancellationToken.None);

                if (result.MessageType == WebSocketMessageType.Close)
                {
                    await socket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Closed by client", CancellationToken.None);
                    gameSockets[gameId].Remove(socket);
                }
                else if (result.MessageType == WebSocketMessageType.Text)
                {
                    var clientMsg = Encoding.UTF8.GetString(buffer, 0, result.Count);
                    await SendMessageToGroup(clientMsg, gameId, gameSockets);
                }
            }
        }

        private static async Task SendMessageToGroup(
                string message,
                string gameId,
                Dictionary<string, List<WebSocket>> gameSockets)
        {
            var buffer = Encoding.UTF8.GetBytes(message);
            var segment = new ArraySegment<byte>(buffer);

            if (!gameSockets.ContainsKey(gameId)) return;

            foreach (var socket in gameSockets[gameId].ToList())
            {
                if (socket.State == WebSocketState.Open)
                {
                    await socket.SendAsync(segment, WebSocketMessageType.Text, true, CancellationToken.None);
                }
            }
        }

    }

}
