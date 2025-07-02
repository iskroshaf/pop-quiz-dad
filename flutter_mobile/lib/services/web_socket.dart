import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel? channel;

void connectWebSocket(String sessionId, Function(String) logMessage) {
  if (sessionId.trim().isEmpty) {
    logMessage("Please enter Session ID before connecting.");
    return;
  }

  final url =
      'ws://156.67.218.162:7267/ws?sessionId=${Uri.encodeComponent(sessionId)}';
  channel = WebSocketChannel.connect(Uri.parse(url));

  logMessage("Connecting to WebSocket...");

  channel!.stream.listen(
    (message) {
      logMessage("Message from server: $message");
    },
    onDone: () {
      logMessage("WebSocket connection closed");
    },
    onError: (error) {
      logMessage("WebSocket error: $error");
    },
  );
}

void sendWebSocketMessage(String message) {
  if (channel != null) {
    channel!.sink.add(message);
    print("Sent WebSocket message: $message");
  } else {
    print("WebSocket not connected. Cannot send message.");
  }
}

