import 'package:flutter/material.dart';

abstract class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2563EB);
  static const Color lightSecondary = Color(0xFF10B981);
  static const Color lightAccent = Color(0xFFF59E0B);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextHint = Color(0xFF94A3B8);
  static const Color lightIcon = Color(0xFF64748B);
  static const Color lightIconSecondary = Color(0xFF94A3B8);
  static const Color lightSearchBar = Color(0xFFF1F5F9);
  static const Color lightTabBackground = Color(0xFFF8FAFC);
  static const Color lightTabActive = Color(0xFFFFFFFF);
  // ✅ Bottom navigation için theme'le uyumlu renkler
  static const Color lightBottomNavBackground = Color(0xFFF8FAFC); // lightSurface ile aynı
  static const Color lightBottomNavBorder = Color(0xFFE2E8F0); // lightBorder ile aynı
  
  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkSecondary = Color(0xFF10B981);
  static const Color darkAccent = Color(0xFFF59E0B);
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCardBackground = Color(0xFF404040);
  static const Color darkBorder = Color(0xFF525252);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextHint = Color(0xFF8A8A8A);
  static const Color darkIcon = Color(0xFFB3B3B3);
  static const Color darkIconSecondary = Color(0xFF8A8A8A);
  static const Color darkSearchBar = Color(0xFF525252);
  static const Color darkTabBackground = Color(0xFF525252);
  static const Color darkTabActive = Color(0xFF404040);
  // ✅ Bottom navigation için theme'le uyumlu renkler
  static const Color darkBottomNavBackground = Color(0xFF2D2D2D); // darkSurface ile aynı
  static const Color darkBottomNavBorder = Color(0xFF525252); // darkBorder ile aynı
  
  // Status Colors
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);
}