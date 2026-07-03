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

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: backgroundLight,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          color: textDark,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: GoogleFonts.nunito(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: textDark,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: textLight,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
