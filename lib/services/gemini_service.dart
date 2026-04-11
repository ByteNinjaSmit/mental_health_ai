import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Future<String> sendMessage(String message) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

    if (apiKey == "YOUR_GEMINI_API_KEY" || apiKey.isEmpty) {
      return "Config Error: Please provide a valid Gemini API Key in gemini_service.dart to start the conversation.";
    }

    try {
      print("Gemini: Sending request to $url");
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "SYSTEM: You are a compassionate, professional mental health companion. Your goal is to provide empathetic support, active listening, and gentle guidance. You should NEVER give medical diagnoses or specific treatment advice. If a user expresses self-harm or immediate crisis, prioritize directing them to professional helplines. Keep responses brief, warm, and focused on the user's emotional well-being.\n\nUSER MESSAGE: $message"
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          },
        }),
      );

      print("Gemini: Response Status Code: ${response.statusCode}");
      print("Gemini: Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
           return data['candidates'][0]['content']['parts'][0]['text'];
        }
        return "I'm here for you, but I'm having a bit of trouble processing that right now. Could you please try again?";
      } else {
        return "I'm currently unable to connect to my therapeutic core (Error ${response.statusCode}). Please check your API key or internet connection.";
      }
    } catch (e) {
      print("Gemini Error: $e");
      return "I'm having a momentary connection issue ($e). I'm still here for you—let's keep talking in a moment.";
    }
  }

  Future<String> analyzeTrend(List<Map<String, dynamic>> history) async {
    if (apiKey == "YOUR_GEMINI_API_KEY" || apiKey.isEmpty) {
      return "Config Error: Please provide a valid Gemini API Key.";
    }

    final String historyText = history.map((e) {
      return "[${e['timestamp']}] ${e['type']}: ${e['result']}";
    }).join("\n");

    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "SYSTEM: You are a Mental Health Trend Analyst. Analyze the following user assessment history and provide a compassionate, insightful 2-sentence summary. Identify any patterns (e.g., recurring moods, anxiety trends) and offer one gentle, personalized piece of advice. Do NOT provide medical diagnoses.\n\nHISTORY:\n$historyText"
                }
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
      return "I need a bit more data to see a pattern. Keep checking in with me!";
    } catch (e) {
      return "I'm having trouble seeing the patterns right now, but every check-in you do helps me understand you better.";
    }
  }
}