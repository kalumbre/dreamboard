import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bluePastel   = Color(0xFFB8D4F0);
  static const Color purplePastel = Color(0xFFD4B8F0);
  static const Color pinkPastel   = Color(0xFFF0B8D4);
  static const Color orangePastel = Color(0xFFF0D4B8);
  static const Color mintPastel   = Color(0xFFB8F0D4);
  static const Color lavender     = Color(0xFFE8D5F5);
  static const Color background   = Color(0xFFFAF7FF);
  static const Color cardBg       = Color(0xFFFFFFFF);
  static const Color softGray     = Color(0xFFF5F3F8);
  static const Color textDark     = Color(0xFF2D2140);
  static const Color textMedium   = Color(0xFF6B5B8A);
  static const Color textLight    = Color(0xFFB0A4C8);

  static const LinearGradient dreamGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD4B8F0),
      Color(0xFFB8D4F0),
      Color(0xFFF0B8D4),
    ],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8D5F5),
      Color(0xFFD4E8F5),
      Color(0xFFF5D4E8),
    ],
  );
}

class AppTheme {

  // Tema dinámico basado en color elegido
  static ThemeData themeFromColor(Color primary) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        background: AppColors.background,
        surface: AppColors.cardBg,
      ),

      textTheme: GoogleFonts.poppinsTextTheme(),

      // ✅ CORREGIDO
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softGray,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: primary,
            width: 2,
          ),
        ),

        hintStyle: GoogleFonts.poppins(
          color: AppColors.textLight,
        ),
      ),
    );
  }

  static ThemeData get theme =>
      themeFromColor(AppColors.purplePastel);
}