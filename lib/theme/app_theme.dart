import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Updated for "Deep Dark" look
  static const Color background = Color(0xFF0F0F16); // Deep Charcoal/Black
  static const Color surface = Color(0xFF1C1C26); // Slightly lighter for cards
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color secondaryPurple = Color(0xFFA78BFA);
  static const Color neonAccent = Color(0xFFC4B5FD);
  
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9CA3AF);
  
  static const LinearGradient coreGradient = LinearGradient(
    colors: [primaryPurple, secondaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2E2E3A), Color(0xFF1C1C26)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: neonAccent,
        surface: surface,
      ),
      cardColor: surface,
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(background),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(10),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: textWhite,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
        displayMedium: GoogleFonts.outfit(
          color: textWhite,
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textWhite,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textGrey,
          fontSize: 14,
        ),
      ),
    );
  }
}
