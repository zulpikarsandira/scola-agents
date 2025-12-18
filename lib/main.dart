import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_voice_app/theme/app_theme.dart';
import 'package:ai_voice_app/screens/home_screen.dart';
import 'package:ai_voice_app/screens/active_session_screen.dart';
import 'package:ai_voice_app/screens/topic_selection_screen.dart';
import 'package:ai_voice_app/screens/summary_screen.dart';
import 'package:ai_voice_app/screens/profile_screen.dart';

import 'package:ai_voice_app/screens/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
    statusBarIconBrightness: Brightness.light, // White icons
  ));
  runApp(const AiVoiceApp());
}

class AiVoiceApp extends StatelessWidget {
  const AiVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Voice Education',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/active_session': (context) => const ActiveSessionScreen(),
        '/topics': (context) => const TopicSelectionScreen(),
        '/summary': (context) => const SummaryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat_screen': (context) => const ChatScreen(),
      },
    );
  }
}
