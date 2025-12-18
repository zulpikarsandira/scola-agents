import 'package:ai_voice_app/widgets/background_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Abstract Background
          const BackgroundDecoration(),

          // 2. Hero Image Background (Scola) - Full Width/Height behind content
          Positioned.fill(
            bottom: 200, // Leave some space at bottom for card overlap if needed, or just fill
            child: Image.asset(
              'assets/scola.png',
              fit: BoxFit.cover, // Fills the area
              alignment: Alignment.topCenter,
            ).animate().fadeIn(duration: 800.ms),
          ),
          
          // 3. Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          // Header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildGlassIcon(LucideIcons.menu),
                            CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                    child: const Icon(LucideIcons.user, color: Colors.white),
                                  ),
                              ],
                            ),
                          ),

                          const Spacer(),
                          // Spacer replaces the center image widget since image is now in background
                          
                          const Spacer(),

                          // 4. Bottom Sheet Card
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: const BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20,
                                  offset: Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Diskusi dengan\nGuru AI Virtual",
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.1),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Tanyakan apa saja kepada guru virtual\nseputar pendidikan.",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 16),
                                ),
                                const SizedBox(height: 40),
                                
                                // Get Started Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(context, '/topics'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Mulai Sekarang",
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ).animate().slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassIcon(IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
