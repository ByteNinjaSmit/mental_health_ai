import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "YOUR_GEMINI_API_KEY";

  Future<String> sendMessage(String message) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "You are a helpful mental health assistant. Be supportive and calm. User: $message"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "Error: Unable to get response";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}