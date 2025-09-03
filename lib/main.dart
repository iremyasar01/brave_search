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
  
  await _initializeApp();
  
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
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
          final themeCubit = context.read<ThemeCubit>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Brave Search Browser',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeCubit.themeMode, // ThemeCubit'teki getter'ı çağırıyo.
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}