import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

import 'dart:async';

class PulsatingAvatar extends StatefulWidget {
  final double size;
  final String imagePath; 
  final bool isSpeaking;

  const PulsatingAvatar({
    super.key,
    this.size = 120,
    required this.imagePath,
    this.isSpeaking = false,
  });

  @override
  State<PulsatingAvatar> createState() => _PulsatingAvatarState();
}

class _PulsatingAvatarState extends State<PulsatingAvatar> {
  Timer? _timer;
  bool _showAlternate = false;

  @override
  void initState() {
    super.initState();
    if (widget.isSpeaking) {
      _startTalkingAnimation();
    }
  }

  @override
  void didUpdateWidget(PulsatingAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking != oldWidget.isSpeaking) {
      if (widget.isSpeaking) {
        _startTalkingAnimation();
      } else {
        _stopTalkingAnimation();
      }
    }
  }

  void _startTalkingAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          _showAlternate = !_showAlternate;
        });
      }
    });
  }

  void _stopTalkingAnimation() {
    _timer?.cancel();
    if (mounted) {
      setState(() {
        _showAlternate = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getCurrentImagePath() {
    if (!_showAlternate || widget.imagePath.isEmpty) return widget.imagePath;
    
    // Construct alternate path: "assets/pak budi.png" -> "assets/pak_budi_1-removebg-preview.png"
    if (widget.imagePath.endsWith('.png')) {
       String base = widget.imagePath.replaceAll('.png', '');
       base = base.replaceAll(' ', '_'); // "assets/pak_budi"
       return '${base}_1-removebg-preview.png';
    }
    return widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      child: Stack(
        clipBehavior: Clip.none, // Allow pop-out
        alignment: Alignment.center,
        children: [
          // Pulse rings
          if (widget.isSpeaking)
            for (int i = 0; i < 3; i++)
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                    duration: 2.seconds,
                    delay: (i * 600).ms,
                    curve: Curves.easeOut,
                  )
                  .fadeOut(
                    duration: 2.seconds,
                    delay: (i * 600).ms,
                    curve: Curves.easeOut,
                  ),

          // Main Avatar Circle
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)], // lighter blue to blue
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
              // Remove background image here, detailed image is separate
            ),
            child: widget.imagePath.isEmpty 
                ? Center(
                    child: Icon(
                      Icons.person, // Placeholder for actual image
                      size: widget.size * 0.5,
                      color: Colors.white,
                    ),
                  )
                : null,
          ).animate(target: widget.isSpeaking ? 1 : 0).shimmer(
                duration: 2.seconds,
                color: Colors.white.withValues(alpha: 0.5),
              ),

          // Pop-out Image (Overlay)
          if (widget.imagePath.isNotEmpty)
            Positioned(
              bottom: 0, // Align bottom
              child: Image.asset(
                _getCurrentImagePath(),
                width: widget.size * 1.2, // 20% larger pop-out
                height: widget.size * 1.2,
                fit: BoxFit.cover,
                gaplessPlayback: true, // Important for smooth swapping
              )
              .animate(target: widget.isSpeaking ? 1 : 0)
              .scale(
                end: const Offset(1.05, 1.05), // Subtle scale pulse when speaking
                duration: 500.ms,
              ),
            ),
        ],
      ),
    );
  }
}
