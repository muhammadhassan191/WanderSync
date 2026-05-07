import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF6C63FF),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6C63FF),
        secondary: Color(0xFF00BFA6),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: Color(0xFFCF6679),
      ),
    );
  }
}
