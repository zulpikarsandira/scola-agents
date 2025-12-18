import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/pulsating_avatar.dart';
import '../widgets/app_drawer.dart';
import '../services/openrouter_service.dart';
import '../services/elevenlabs_service.dart';
import '../config/api_keys.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  // Services
  final OpenRouterService _openRouterService = OpenRouterService(
    apiKey: Config.openRouterKey,
  );
  final ElevenLabsService _elevenLabsService = ElevenLabsService(
    apiKey: Config.elevenLabsKey,
  );
  
  // Audio / STT
  final SpeechToText _speechToText = SpeechToText();
  late final AudioPlayer _audioPlayer; // For ElevenLabs Output
  
  // State
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';
  bool _isProcessing = false;
  bool _isSpeaking = false;
  String _teacherImage = '';
  String _teacherName = '';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initSpeech();
    
    // Listen to player completion
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
        // Optionally restart listening
      }
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, String>) {
       if (args.containsKey('image')) _teacherImage = args['image']!;
       if (args.containsKey('name')) _teacherName = args['name']!;
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled || _isProcessing || _isSpeaking) return;

    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'id-ID'); // Listen for Indonesian
    setState(() {
      _isListening = true;
      _lastWords = '';
    });
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
    
    // If we have words, send to AI
    if (_lastWords.isNotEmpty) {
      _processInput(_lastWords);
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    
    if (result.finalResult) {
       _stopListening();
    }
  }

  bool _hasGreeted = false;

  String _getSystemPrompt(String teacherName) {
    // Default fallback
    String name = teacherName.isNotEmpty ? teacherName : "Guru";
    
    String prompt = "Kamu adalah $name, seorang guru yang ramah, ceria, dan menyenangkan. "
           "Gunakan bahasa Indonesia yang santai dan mudah dimengerti oleh anak-anak. "
           "Jangan terlalu kaku. Tujuanmu adalah membuat belajar menjadi seru.";

    if (!_hasGreeted) {
      prompt += " Jika ini awal percakapan, katakan: 'Halo siswa pengen belajar apa hari ini dengan $name?'";
    } else {
      prompt += " Lanjutkan percakapan dengan natural. Jangan mengulang perkenalan diri.";
    }
    
    return prompt;
  }

  Future<void> _processInput(String input) async {
    setState(() {
      _isProcessing = true;
      _lastWords = ''; 
    });

    // 1. Get Text from Gemma with Persona
    final responseText = await _openRouterService.chatWithText(
      input, 
      systemPrompt: _getSystemPrompt(_teacherName)
    );

    if (responseText != null) {
      // Mark as greeted after getting first response
      _hasGreeted = true; 
      
      // 2. Get Audio from ElevenLabs
      await _speakResponse(responseText);
    } else {
      setState(() {
         _isProcessing = false;
      });
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No response from AI')));
      }
    }
  }

  Future<void> _speakResponse(String text) async {
    try {
       // Voice ID based on teacher
       final voiceId = _elevenLabsService.getVoiceId(_teacherName);
       
       final audioBytes = await _elevenLabsService.textToSpeech(text: text, voiceId: voiceId);
       
       setState(() {
         _isProcessing = false;
       });

       if (audioBytes != null) {
         setState(() {
           _isSpeaking = true;
         });
         await _audioPlayer.play(BytesSource(Uint8List.fromList(audioBytes)));
       } else {
          // Fallback?
          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to generate speech')));
       }
    } catch (e) {
      print("TTS Error: $e");
      setState(() {
        _isProcessing = false;
        _isSpeaking = false;
      });
    }
  }

  void _toggleRecording() {
    if (_isListening) {
      _stopListening();
    } else if (_isSpeaking) {
       _audioPlayer.stop(); // Allow interrupting
       setState(() => _isSpeaking = false);
    } else {
      _startListening();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F16), // Dark background
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(LucideIcons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Scola Agent", // Changed from Active Session
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            const Spacer(flex: 2),

            // Avatar with Rings
            Stack(
              alignment: Alignment.center,
              children: [
                 // Outer Glow Rings
                 if (_isListening || _isSpeaking || _isProcessing)
                  for (int i = 0; i < 3; i++)
                    Container(
                      width: 250 + (i * 60.0),
                      height: 250 + (i * 60.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1 - (i * 0.03)),
                          width: 1,
                        ),
                      ),
                    ).animate(
                      onPlay: (c) => c.repeat(reverse: true),
                      target: (_isProcessing) ? 0 : 1, 
                    ).scale(
                      duration: (_isProcessing) ? 1.seconds : (2 + i).seconds, 
                      begin: const Offset(0.9, 0.9), 
                      end: const Offset(1.1, 1.1)
                    ),
                
                // Main Avatar
                PulsatingAvatar(
                  imagePath: _teacherImage,
                  isSpeaking: _isSpeaking || _isProcessing, // Pulse when AI speaks/thinks
                  size: 160,
                ),
                
                // Status Indicator Text
                Positioned(
                  bottom: -50,
                  child: Column(
                    children: [
                      Text(
                        _statusText,
                        style: GoogleFonts.outfit(
                          color: Colors.white70,  // Light text
                          fontSize: 16,
                        ),
                      ),
                      // Show recognized text for feedback
                      if (_lastWords.isNotEmpty && _isListening)
                         Padding(
                           padding: const EdgeInsets.only(top: 8.0),
                           child: Container(
                             constraints: const BoxConstraints(maxWidth: 300),
                             child: Text(
                               _lastWords,
                               textAlign: TextAlign.center,
                               style: GoogleFonts.outfit(
                                 color: Colors.white54,
                                 fontSize: 12,
                               ),
                             ),
                           ),
                         ),
                    ],
                  ),
                )
              ],
            ),

            const Spacer(flex: 3),
            
            // Bottom Controls
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F20), // Dark Pill
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildControlIcon(LucideIcons.micOff, false, onTap: () {}),
                  
                   // Main Mic/Action Button
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                       padding: const EdgeInsets.all(16),
                       decoration: const BoxDecoration(
                         color: Colors.white, 
                         shape: BoxShape.circle,
                       ),
                       child: Icon(
                         _isListening 
                           ? LucideIcons.stopCircle 
                           : (_isSpeaking ? LucideIcons.pause : LucideIcons.mic), 
                         color: Colors.black, 
                         size: 28
                        ),
                    ),
                  ),
                  
                  _buildControlIcon(LucideIcons.hand, false, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _statusText {
    if (_isProcessing) return "Thinking...";
    if (_isSpeaking) return "Speaking...";
    if (_isListening) return "Listening...";
    return "Tap mic to speak";
  }

  Widget _buildControlIcon(IconData icon, bool isActive, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isActive ? Colors.black : Colors.white54, size: 24),
      ),
    );
  }
}
