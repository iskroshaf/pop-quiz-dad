import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/api_service.dart';

class GameQuestionPage extends StatefulWidget {
  const GameQuestionPage({super.key});

  @override
  State<GameQuestionPage> createState() => _GameQuestionPageState();
}

class _GameQuestionPageState extends State<GameQuestionPage> {
  late Map<String, dynamic> questionData;
  String? selectedAnswer;
  final ApiService apiService = ApiService();

  bool _isSubmitting = false;
  String? sessionId;
  String? username;
  bool _isCheckingGameEnd = false;

  WebSocketChannel? channel;
  List<String> websocketLogs = [];

  final List<Color> avatarColors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.indigo,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
    Colors.green,
    Colors.amber,
  ];

  Color getAvatarColor(String name) {
    final hash = name.codeUnits.fold(0, (prev, curr) => prev + curr);
    return avatarColors[hash % avatarColors.length];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      questionData = args;
      _loadUserData();

      if (questionData['questionNo'] == null && !_isCheckingGameEnd) {
        print('questionNo is null on page load, handling game end');
        _isCheckingGameEnd = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleGameEnd();
        });
      }
    } else {
      questionData = {};
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    sessionId = prefs.getString('sessionId');
    username = prefs.getString('participantName');

    if (sessionId != null) {
      _connectWebSocket(sessionId!);
    }
    setState(() {});
  }

  void _connectWebSocket(String sessionId) {
    final url =
        'ws://156.67.218.162:7267/ws?sessionId=${Uri.encodeComponent(sessionId)}';
    channel = WebSocketChannel.connect(Uri.parse(url));

    channel!.stream.listen(
      (message) {
        _logWebSocketMessageOnly(message);
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  void _logWebSocketMessageOnly(String message) {
    // Don't log your own messages
    if (username != null && message.contains(username!)) return;

    setState(() {
      websocketLogs.add(message);

      // Keep only the last 3 messages (excluding your own, already filtered)
      if (websocketLogs.length > 3) {
        websocketLogs = websocketLogs.sublist(websocketLogs.length - 3);
      }
    });
  }

  void sendWebSocketMessage(String message) {
    if (channel != null) {
      channel!.sink.add(message);
      print("Sent WebSocket message: $message");
    } else {
      print("WebSocket not connected. Cannot send message.");
    }
  }

  Future<void> _handleGameEnd() async {
    print('_handleGameEnd called');
    if (sessionId == null) {
      print('sessionId is null');
      return;
    }

    print('Getting game result for sessionId: $sessionId');
    final gameResult = await apiService.getGameResult(sessionId!);

    if (gameResult != null && gameResult.isNotEmpty) {
      print('Navigating to game result page with data: $gameResult');
      Navigator.pushReplacementNamed(
        context,
        '/game_result',
        arguments: gameResult,
      );
    } else {
      print('Failed to get game results');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Game completed but failed to load results.')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _submitAnswer() async {
    if (selectedAnswer == null || selectedAnswer!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    if (sessionId != null) {
      final gametaskId = questionData['id'];
      final result = await apiService.submitGameAnswer(
          sessionId ?? '', gametaskId, selectedAnswer!);

      final questionNumber = questionData['questionNo'] ?? '';
      final messageToSend =
          '$username had already answered question $questionNumber';
      sendWebSocketMessage(messageToSend);

      final nextQuestion = await apiService.getSessionQuestion(sessionId!);

      if (nextQuestion != null && nextQuestion['questionNo'] != null) {
        print('Next question found: ${nextQuestion['questionNo']}');
        setState(() {
          questionData = nextQuestion;
          selectedAnswer = null;
        });
      } else {
        print(
            'No more questions or questionNo is null. nextQuestion: $nextQuestion');
        await _handleGameEnd();
        return;
      }
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Widget _buildAnswerOption(String label, String value) {
    return RadioListTile<String>(
      title: Text('$label. $value'),
      value: value,
      groupValue: selectedAnswer,
      onChanged: (val) {
        setState(() {
          selectedAnswer = val;
        });
      },
    );
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questionData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No question data available')),
      );
    }

    if (questionData['questionNo'] == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading results...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Question #${questionData['questionNo'] ?? ''}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questionData['question'] ?? 'No question',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 24),
                  _buildAnswerOption("A", questionData['optionA'] ?? ''),
                  _buildAnswerOption("B", questionData['optionB'] ?? ''),
                  _buildAnswerOption("C", questionData['optionC'] ?? ''),
                  _buildAnswerOption("D", questionData['optionD'] ?? ''),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitAnswer,
                      child: const Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: const Color(0xFF4A4A5A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: websocketLogs.length,
                      itemBuilder: (context, index) {
                        final reversedLogs = websocketLogs.reversed.toList();
                        final message = reversedLogs[index];

                        if (username != null && message.contains(username!)) {
                          return const SizedBox.shrink();
                        }

                        final senderName = message.split(' ').first;
                        final avatarLetter = senderName.isNotEmpty
                            ? senderName[0].toUpperCase()
                            : '?';
                        final avatarColor = getAvatarColor(senderName);

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: avatarColor.withOpacity(
                                      0.3), // matching subtle border
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: avatarColor,
                                radius: 20,
                                child: Text(
                                  avatarLetter,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade200),
                                ),
                                child: Text(
                                  message,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
