import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class VoiceVisualizer extends StatelessWidget {
  final bool isListening;

  const VoiceVisualizer({super.key, required this.isListening});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          10,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: isListening ? AppTheme.neonAccent : Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                  target: isListening ? 1 : 0,
                )
                .scaleY(
                  begin: 0.2,
                  end: isListening ? (index % 2 == 0 ? 1.0 : 0.6) : 0.2, // Randomize slightly?
                  duration: (300 + (index * 50)).ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
      ),
    );
  }
}
