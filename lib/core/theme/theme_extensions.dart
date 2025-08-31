import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color searchBarBackground;
  final Color tabBackground;
  final Color tabActiveBackground;
  final Color iconSecondary;
  final Color textHint;
  final Color accent;
  final Color bottomNavBackground;
  final Color bottomNavBorder;

  const AppColorsExtension({
    required this.searchBarBackground,
    required this.tabBackground,
    required this.tabActiveBackground,
    required this.iconSecondary,
    required this.textHint,
    required this.accent,
    required this.bottomNavBackground,
    required this.bottomNavBorder,
  });

  static const AppColorsExtension light = AppColorsExtension(
    searchBarBackground: AppColors.lightSearchBar,
    tabBackground: AppColors.lightTabBackground,
    tabActiveBackground: AppColors.lightTabActive,
    iconSecondary: AppColors.lightIconSecondary,
    textHint: AppColors.lightTextHint,
    accent: AppColors.lightAccent,
    bottomNavBackground: AppColors.lightBottomNavBackground,
    bottomNavBorder: AppColors.lightBottomNavBorder,
  );

  static const AppColorsExtension dark = AppColorsExtension(
    searchBarBackground: AppColors.darkSearchBar,
    tabBackground: AppColors.darkTabBackground,
    tabActiveBackground: AppColors.darkTabActive,
    iconSecondary: AppColors.darkIconSecondary,
    textHint: AppColors.darkTextHint,
    accent: AppColors.darkAccent,
    bottomNavBackground: AppColors.darkBottomNavBackground,
    bottomNavBorder: AppColors.darkBottomNavBorder,
  );

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? searchBarBackground,
    Color? tabBackground,
    Color? tabActiveBackground,
    Color? iconSecondary,
    Color? textHint,
    Color? accent,
    Color? bottomNavBackground,
    Color? bottomNavBorder,
  }) {
    return AppColorsExtension(
      searchBarBackground: searchBarBackground ?? this.searchBarBackground,
      tabBackground: tabBackground ?? this.tabBackground,
      tabActiveBackground: tabActiveBackground ?? this.tabActiveBackground,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      textHint: textHint ?? this.textHint,
      accent: accent ?? this.accent,
      bottomNavBackground: bottomNavBackground ?? this.bottomNavBackground,
      bottomNavBorder: bottomNavBorder ?? this.bottomNavBorder,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    
    return AppColorsExtension(
      searchBarBackground: Color.lerp(searchBarBackground, other.searchBarBackground, t)!,
      tabBackground: Color.lerp(tabBackground, other.tabBackground, t)!,
      tabActiveBackground: Color.lerp(tabActiveBackground, other.tabActiveBackground, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      bottomNavBackground: Color.lerp(bottomNavBackground, other.bottomNavBackground, t)!,
      bottomNavBorder: Color.lerp(bottomNavBorder, other.bottomNavBorder, t)!,
    );
  }
}