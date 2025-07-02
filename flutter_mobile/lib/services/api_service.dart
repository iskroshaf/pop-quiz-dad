import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //development
  // final String domainUrl = 'http://192.168.1.6:7267';
  final String domainUrl = 'http://156.67.218.162:5000';

  late final String baseUrl;

  ApiService() {
    baseUrl = domainUrl + '/api';
  }

  Map<String, dynamic>? joinedParticipant;

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
          'Id': sessionId,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 401) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
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
          'Session': sessionId,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = response.body;

        print('Response: $data');
        return data;
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

  Future<List<Map<String, dynamic>>?> getGameResult(String token) async {
    final url = Uri.parse('$baseUrl/Games/result');

    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return null;
    } catch (e) {
      print('Error parsing game result: $e');
      return null;
    }
  }

  
}