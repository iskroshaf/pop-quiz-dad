import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //development, tukar ip address macheh
  final String domainUrl = 'http://192.168.1.6:7267';

  late final String baseUrl;

  ApiService() {
    baseUrl = domainUrl + '/api';
  }

  /// Stores the joined participant details
  Map<String, dynamic>? joinedParticipant;

  /// Join Game API Call
  Future<String?> joinGame(String participantName, String sessionId) async {
    final url = Uri.parse('$baseUrl/Games/join');

    final Map<String, String> body = {
      "participantName": participantName,
      "sessionId": sessionId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Store the needed data
        joinedParticipant = {
          "participantName": data["participantName"],
          "joinTime": data["joinTime"],
          "status": data["status"],
          "sessionId": data["sessionId"],
        };

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('participantName', data['participantName']);
        await prefs.setString('sessionId', data['sessionId']);

        return null; // success, no error message
      } else if (response.statusCode == 400) {
        return "This username has been used in this game.";
      } else if (response.statusCode == 404) {
        return "Game session not found.";
      } else {
        return "Unexpected error occurred: ${response.statusCode}";
      }
    } catch (e) {
      print('An error occurred: $e');
      return "An error occurred: $e";
    }
  }

  Future<Map<String, dynamic>?> getSessionQuestion(String sessionId) async {
    final url = Uri.parse('$baseUrl/Games/session');

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Id': sessionId, // Custom header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        return null; // Unauthorized
      } else {
        return null; // Other unexpected status
      }
    } catch (e) {
      return null; // Exception handling
    }
  }

  Future<String?> submitGameAnswer(String sessionId, int gametaskId, String selectedAnswer) async {
    final url = Uri.parse('$baseUrl/Games/answer');

    final Map<String, String> body = {
      "gametaskId": gametaskId.toString(),
      "selectedAnswer": selectedAnswer,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Session': sessionId, // Custom header
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = response.body;

        print('Response: $data');
        return data; // success, no error message
      } else if (response.statusCode == 400) {
        print('Response: ' + response.body);
        return "You have answered this question.";
      } else if (response.statusCode == 404) {
        print('Response: ' + response.body);
        return "Game session not found.";
      } else {
        print('Response: ' + response.body);
        return "Unexpected error occurred: ${response.statusCode}";
      }
    } catch (e) {
      print('An error occurred: $e');
      return "An error occurred: $e";
    }
  }
}