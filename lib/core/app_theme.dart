import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // AIko Color Palette - Futuristic & Intelligent
  static const Color primaryDeep = Color(0xFF050B18); // Cyber Navy
  static const Color primaryMid = Color(0xFF0A162F);
  static const Color primaryLight = Color(0xFF102144);
  
  static const Color accentCyan = Color(0xFF00FBFF); // Neon Cyan
  static const Color accentMagenta = Color(0xFFFF00FF); // Vibrant Magenta
  static const Color accentBlue = Color(0xFF2979FF); // Electric Blue
  static const Color accentGold = Color(0xFFFFD700);

  static const Color surfaceCard = Color(0xFF0E1A35);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBlack = Color(0x33000000);
  
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryDeep, primaryMid, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentBlue, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF475569);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: accentCyan,
        secondary: accentMagenta,
        surface: primaryMid,
        onPrimary: primaryDeep,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        error: const Color(0xFFCF6679),
      ),
      scaffoldBackgroundColor: primaryDeep,
      cardColor: surfaceCard,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentCyan,
          foregroundColor: primaryDeep,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.05),
        thickness: 1,
      ),
    );
  }

  // Japanese text style
  static TextStyle japaneseStyle({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w500,
    Color color = textPrimary,
  }) {
    return TextStyle(
      fontFamily: 'NotoSansJP',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
