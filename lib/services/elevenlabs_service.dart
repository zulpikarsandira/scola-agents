import 'dart:convert';
import 'package:http/http.dart' as http;

class ElevenLabsService {
  final String apiKey;
  
  // Voice IDs
  static const String voiceIdBibam = "aVs9Xf3KBQop7qHRGth0"; // Bibam (Pak Budi, Pak Aris)
  static const String voiceIdHoneypie = "3AwU3nHsI4YWeBJbz6yn"; // Honeypie (Buk Rini)

  ElevenLabsService({required this.apiKey});

  String getVoiceId(String teacherName) {
    if (teacherName.toLowerCase().contains("rini")) {
      return voiceIdHoneypie;
    } 
    // Default to Bibam for Pak Budi, Pak Aris, and others
    return voiceIdBibam; 
  }

  Future<List<int>?> textToSpeech({required String text, required String voiceId}) async {
    try {
      // Use optimize_streaming_latency=3 or 4 for max speed (approx 50% latency reduction)
      final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId?optimize_streaming_latency=3');
      
      final response = await http.post(
        url,
        headers: {
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        body: jsonEncode({
          "text": text,
          "model_id": "eleven_multilingual_v2", 
          "voice_settings": {
            "stability": 0.5,
            "similarity_boost": 0.75
          }
        }),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print("ElevenLabs Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error calling ElevenLabs: $e");
      return null;
    }
  }
}
