import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showInDevelopment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur ini dalam pengembangan"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.coreGradient,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                ),
                Positioned(
                  top: 40, left: 16,
                  child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                ),
                
                // Avatar Area
                Positioned(
                  bottom: -50,
                  left: 0, right: 0,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 110, height: 110,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.background),
                        ),
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: GestureDetector(
                            onTap: () => _showInDevelopment(context),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: AppTheme.neonAccent, shape: BoxShape.circle),
                              child: const Icon(LucideIcons.edit2, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            
            Text("Alex Siswa", style: Theme.of(context).textTheme.displayMedium),
            Text("Level 5 - Explorer", style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 30),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat("12", "Sesi", LucideIcons.mic),
                _buildStat("5.2", "Jam", LucideIcons.clock),
                _buildStat("850", "Poin", LucideIcons.award),
              ],
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Riwayat Belajar", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildHistoryRow("Aljabar Linear", "Hari ini", 15),
                    _buildHistoryRow("Conversation Practice", "Kemarin", 20),
                    _buildHistoryRow("Hukum Fisika", "2 hari lalu", 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.neonAccent, size: 24),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white54)),
      ],
    );
  }

  Widget _buildHistoryRow(String title, String date, int duration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500)),
              Text(date, style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("$duration m", style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
