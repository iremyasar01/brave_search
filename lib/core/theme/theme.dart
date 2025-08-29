import 'package:flutter/material.dart';

class AppColorSchemes {
  static ColorScheme lightScheme() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF2003), // Brave turuncusu
      brightness: Brightness.light,
      primary: const Color(0xFFFF2003),
      secondary: const Color(0xFF342B2A),
      surface: Colors.white,
    );
  }

  static ColorScheme darkScheme() {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5E4D), // Daha açık turuncu
      brightness: Brightness.dark,
      primary: const Color(0xFFFF5E4D),
      secondary: const Color(0xFFE6E0DE),
      surface: const Color(0xFF1C1C1C),
    );
  }
}