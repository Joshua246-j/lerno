import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Vibrant Blue for primary text/buttons
  static const Color primaryBlue = Color(0xFF1EA1F2);
  static const Color primaryLight = Color(0xFFE8F4FD);
  static const Color secondaryBlue = Color(0xFF4AC4FA);

  // Very light gray/blue background
  static const Color backgroundLight = Color(0xFFF4F7FB);

  // Text colors
  static const Color textDark = Color(0xFF1C2731);
  static const Color textLight = Color(0xFF8A9BA8);

  // Pastels for Profile/Stats
  static const Color pastelPurple = Color(0xFFE6E1FF);
  static const Color pastelGreen = Color(0xFFD9F4C7);
  static const Color pastelBlue = Color(0xFFC7EEF9);

  static const Color primaryGreen = Color(0xFF75C73F);
  static const Color cardWhite = Colors.white;

  // Typography
  static TextTheme _buildTextTheme() {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        color: textDark,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.outfit(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: GoogleFonts.outfit(
        color: textDark,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.outfit(
        color: textLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: backgroundLight,
      ),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          elevation: 8,
          shadowColor: primaryBlue.withValues(alpha: 0.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 15,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  // --- Modern UI Utilities ---

  // Standard drop shadow for floating cards
  static List<BoxShadow> get modernShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: primaryBlue.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  // Primary Gradient Backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B80F9), // Purple
      Color(0xFF1EA1F2), // Light Blue
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFBBF24), // Gold/Yellow
      Color(0xFFF59E0B), // Darker Orange
    ],
  );
}
