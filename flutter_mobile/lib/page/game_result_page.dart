import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameResultPage extends StatefulWidget {
  const GameResultPage({super.key});

  @override
  State<GameResultPage> createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage> {
  String? currentUsername;
  List<Map<String, dynamic>> allResults = [];
  Map<String, dynamic>? currentPlayerResult;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final results = ModalRoute.of(context)?.settings.arguments;
    print('GameResultPage - Results received: $results');

    if (results != null) {
      if (results is List) {
        allResults = List<Map<String, dynamic>>.from(results);
      } else if (results is Map<String, dynamic>) {
        allResults = [results];
      }

      allResults.sort((a, b) {
        final accuracyA = (a['accuracy'] ?? 0.0).toDouble();
        final accuracyB = (b['accuracy'] ?? 0.0).toDouble();

        if (accuracyA != accuracyB) {
          return accuracyB.compareTo(accuracyA);
        }

        final timeA = (a['time'] ?? 0.0).toDouble();
        final timeB = (b['time'] ?? 0.0).toDouble();
        return timeA.compareTo(timeB);
      });

      _findCurrentPlayer();
    }
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      currentUsername = prefs.getString('participantName');
    });

    _findCurrentPlayer();
  }

  void _findCurrentPlayer() {
    if (currentUsername != null) {
      currentPlayerResult = allResults.firstWhere(
            (result) => result['participantName'] == currentUsername,
        orElse: () => {},
      );
      if (currentPlayerResult!.isEmpty) {
        currentPlayerResult = null;
      }
    }
  }

  int _getRank(String participantName) {
    return allResults.indexWhere((result) => result['participantName'] == participantName) + 1;
  }

  @override
  Widget build(BuildContext context) {
    if (allResults.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No result data available')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Game Results'),
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Current Player Summary (if found)
            if (currentPlayerResult != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFF8B7ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Result',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      currentPlayerResult!['participantName'] ?? 'You',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          'Rank',
                          '#${_getRank(currentPlayerResult!['participantName'])}',
                          Colors.white,
                        ),
                        _buildStatItem(
                          'Accuracy',
                          '${((currentPlayerResult!['accuracy'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                          Colors.white,
                        ),
                        _buildStatItem(
                          'Score',
                          '${currentPlayerResult!['correctCount']}/${currentPlayerResult!['progress']}',
                          Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Leaderboard Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '🏆 Leaderboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 12),

            // Leaderboard List
            Expanded(
              child: ListView.builder(
                itemCount: allResults.length,
                itemBuilder: (context, index) {
                  final result = allResults[index];
                  final rank = index + 1;
                  final isCurrentPlayer = result['participantName'] == currentUsername;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCurrentPlayer ? const Color(0xFF6C5CE7).withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isCurrentPlayer ? Border.all(color: const Color(0xFF6C5CE7), width: 2) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Rank
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getRankColor(rank),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              rank <= 3 ? _getRankEmoji(rank) : '$rank',
                              style: TextStyle(
                                fontSize: rank <= 3 ? 20 : 16,
                                fontWeight: FontWeight.bold,
                                color: rank <= 3 ? Colors.white : const Color(0xFF6C5CE7),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Player Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    result['participantName'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isCurrentPlayer ? const Color(0xFF6C5CE7) : const Color(0xFF2D3748),
                                    ),
                                  ),
                                  if (isCurrentPlayer) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6C5CE7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'YOU',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${result['correctCount']}/${result['progress']} correct • ${((result['accuracy'] ?? 0).toDouble() * 100).toStringAsFixed(1)}% • ${(result['time'] ?? 0.0).toStringAsFixed(1)}s',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Completion Status
                        Icon(
                          result['completed'] == true ? Icons.check_circle : Icons.pending,
                          color: result['completed'] == true ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                            (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF6C5CE7)),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFFF7F7F7); // Default
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank';
    }
  }
}