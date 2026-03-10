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

  static const Color surfaceCardDark = Color(0xFF0E1A35);
  static const Color surfaceCardLight = Color(0xFFF0F4F8);
  
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);

  static LinearGradient premiumGradient(bool isDark) => LinearGradient(
    colors: isDark 
      ? [primaryDeep, primaryMid, primaryLight]
      : [const Color(0xFFFFFFFF), const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentBlue, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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
        onSurface: textPrimaryDark,
      ),
      scaffoldBackgroundColor: primaryDeep,
      textTheme: _buildTextTheme(textPrimaryDark, textSecondaryDark),
      appBarTheme: _buildAppBarTheme(textPrimaryDark),
      cardTheme: _buildCardTheme(surfaceCardDark, isDark: true),
      elevatedButtonTheme: _buildButtonTheme(accentCyan, primaryDeep),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: accentBlue,
        secondary: accentMagenta,
        surface: const Color(0xFFF8FAFC),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: _buildTextTheme(textPrimaryLight, textSecondaryLight),
      appBarTheme: _buildAppBarTheme(textPrimaryLight),
      cardTheme: _buildCardTheme(surfaceCardLight, isDark: false),
      elevatedButtonTheme: _buildButtonTheme(accentBlue, Colors.white),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
      displayMedium: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: primary),
      headlineLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
      headlineMedium: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: primary),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: secondary),
    );
  }

  static AppBarTheme _buildAppBarTheme(Color text) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: text),
      iconTheme: IconThemeData(color: text),
    );
  }

  static const Color textHint = Color(0xFF64748B);
  static const Color surfaceCard = Color(0xFF0E1A35); // Default to dark

  static CardThemeData _buildCardTheme(Color color, {required bool isDark}) {
    return CardThemeData(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
    );
  }

  static ElevatedButtonThemeData _buildButtonTheme(Color bg, Color text) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.0),
      ),
    );
  }

  static TextStyle japaneseStyle({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'NotoSansJP',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
