import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const apiKey = 'sk_9b3b1bb33b579a373505f99975d158973484d9aef149aacb';
  final url = Uri.parse('https://api.elevenlabs.io/v1/voices');

  try {
    final response = await http.get(
      url,
      headers: {
        'xi-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final voices = data['voices'] as List;
      
      print("Found ${voices.length} voices.");
      for (var voice in voices) {
        print("Name: ${voice['name']}, ID: ${voice['voice_id']}");
      }
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
  }
}
