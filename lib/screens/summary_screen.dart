import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text("Ringkasan", style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
                  const SizedBox(width: 48), // Balance
                ],
              ),
              const SizedBox(height: 30),

              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.check, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Sesi Selesai",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 32),
                    _buildPoint("Konsep dasar aljabar linear"),
                    _buildPoint("Perbedaan vektor dan skalar"),
                    _buildPoint("Contoh soal latihan 1-3"),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                "Kosakata Baru",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag("Eigenvalue"),
                  _buildTag("Matrix"),
                  _buildTag("Determinant"),
                ],
              ),

              const SizedBox(height: 40),
              
              NeonButton(
                text: "Latihan Ulang",
                icon: LucideIcons.refreshCw,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              NeonButton(
                text: "Kirim ke Guru",
                icon: LucideIcons.send,
                isPrimary: false,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppTheme.neonAccent),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: GoogleFonts.inter(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(text, style: GoogleFonts.inter(color: AppTheme.neonAccent)),
    );
  }
}
