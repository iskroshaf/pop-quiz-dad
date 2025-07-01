import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      questionData = args;
      _loadUserData();
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

    // if (result == "You have answered this question.") {

    // }

    // Get next question
    if (sessionId != null) {

      final gametaskId = questionData['id'];
      final result = await apiService.submitGameAnswer(sessionId ?? '', gametaskId, selectedAnswer!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result!)),
      );

      final nextQuestion = await apiService.getSessionQuestion(sessionId!);
      if (nextQuestion != null) {
        setState(() {
          questionData = nextQuestion;
          selectedAnswer = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No more questions or session expired.')),
        );
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final next = await apiService.getSessionQuestion(sessionId!);
      //     if (next != null) {
      //       setState(() {
      //         questionData = next;
      //         selectedAnswer = null;
      //       });
      //     }
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
    );

  }
}
