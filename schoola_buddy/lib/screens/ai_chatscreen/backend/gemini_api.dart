import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schoola_buddy/api.dart'; // Add this import

class GeminiService {
  // Replace with your actual API key
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${Api.geminiApiKey}';

  static Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the response body is structured as expected
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('❌ Gemini API Error: ${response.statusCode}');
        print('🧾 Response body: ${response.body}');
        return 'Error: Failed to get response from Gemini API.';
      }
    } catch (e) {
      print('🚨 Exception caught: $e');
      return 'Error: $e';
    }
  }
}
