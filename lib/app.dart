import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/di/injection.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/core/theme/app_theme.dart';
import 'package:brave_search/core/theme/theme_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';
import 'package:brave_search/presentations/splash/splash_screen.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        BlocProvider(create: (context) => getIt<HistoryCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          final themeCubit = context.read<ThemeCubit>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstant.braveSearchBrowser,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeCubit.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
