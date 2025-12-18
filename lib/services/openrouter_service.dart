import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  final String apiKey;
  final String siteUrl;
  final String siteName;

  OpenRouterService({
    required this.apiKey,
    this.siteUrl = 'https://ai_voice_app.com', // Placeholder
    this.siteName = 'AI Voice App',
  });

  Future<String?> chatWithText(String userText, {String? systemPrompt, String model = "google/gemma-3n-e2b-it:free"}) async {
    try {
      final defaultPrompt = "You are a helpful AI teacher. Respond in Indonesian language. Keep responses concise and conversational.";
      
      List<Map<String, String>> messages = [];
      String sysContent = systemPrompt ?? defaultPrompt;

      if (model.contains("gemma")) {
        // Gemma models via Google provider often don't support 'system' role cleanly via some endpoints
        // Merge system prompt into user message
        messages.add({
          "role": "user",
          "content": "System Instructions:\n$sysContent\n\nUser Message:\n$userText"
        });
      } else {
        // Standard behavior
        messages.add({
          "role": "system",
          "content": sysContent
        });
        messages.add({
          "role": "user",
          "content": userText
        });
      }

      final Map<String, dynamic> bodyMap = {
        "model": model,
        "messages": messages,
      };

      if (!model.contains("gemma")) {
         bodyMap["frequency_penalty"] = 0.5;
         bodyMap["presence_penalty"] = 0.5;
      }

      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "HTTP-Referer": siteUrl,
          "X-Title": siteName,
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyMap),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content;
      } else {
        print("OpenRouter Error: ${response.body}");
        return null; // Handle error gracefully (maybe return error message string in real app)
      }
    } catch (e) {
      print("Exception calling OpenRouter: $e");
      return null;
    }
  }
}
