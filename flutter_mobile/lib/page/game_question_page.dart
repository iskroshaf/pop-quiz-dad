import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'game_result_page.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      questionData = args;
      _loadUserData();

      // Check if game is already ended when page loads
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

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionId = prefs.getString('sessionId');
      username = prefs.getString('participantName');
    });
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
        const SnackBar(content: Text('Game completed but failed to load results.')),
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
      final result = await apiService.submitGameAnswer(sessionId ?? '', gametaskId, selectedAnswer!);

      // Get next question
      final nextQuestion = await apiService.getSessionQuestion(sessionId!);

      if (nextQuestion != null && nextQuestion['questionNo'] != null) {
        // Still have more questions with valid question number
        print('Next question found: ${nextQuestion['questionNo']}');
        setState(() {
          questionData = nextQuestion;
          selectedAnswer = null;
        });
      } else {
        // No more questions or questionNo is null - game is complete, get results
        print('No more questions or questionNo is null. nextQuestion: $nextQuestion');
        await _handleGameEnd();
        return; // Exit early since we're navigating away
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
  Widget build(BuildContext context) {
    if (questionData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No question data available')),
      );
    }

    // If questionNo is null, show loading while handling game end
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
          ],
        ),
      ),
    );
  }
}