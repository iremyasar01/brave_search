import 'package:brave_search/presentations/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection.dart';
import 'core/network/cubit/network_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'presentations/browser/cubit/browser_cubit.dart';
import 'presentations/web/cubit/web_search_cubit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Uygulama başlangıç yüklemeleri
  await _initializeApp();
  
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  // Environment variables yükle
  await dotenv.load(fileName: ".env");
  
  // Dependency injection'ı kur
  configureDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<NetworkCubit>()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => getIt<BrowserCubit>()),
        BlocProvider(create: (context) => getIt<WebSearchCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Brave Search Browser',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getThemeMode(themeMode),
            home: const SplashScreen(), // Splash screen'i başlangıç ekranı yap
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}