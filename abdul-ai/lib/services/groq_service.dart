import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class GroqService {
  static const String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.groqApiKey}',
        },
        body: jsonEncode({
          'model': 'mixtral-8x7b-32768',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Unable to fetch information';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
