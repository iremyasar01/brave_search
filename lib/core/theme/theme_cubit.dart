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
        emit(AppThemeMode.dark);
        break;
    }
  }
}