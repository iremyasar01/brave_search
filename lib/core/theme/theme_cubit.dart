import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppThemeMode { light, dark, system }

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.system);

  void setTheme(AppThemeMode mode) {
    emit(mode);
  }

  void toggleTheme() {
    switch (state) {
      case AppThemeMode.light:
        emit(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        emit(AppThemeMode.light);
        break;
      case AppThemeMode.system:
        // Sistem temasındayken toggle edince light tema yapalım.
        emit(AppThemeMode.light);
        break;
    }
  }

  // ThemeMode dönüşümü için getter
  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}