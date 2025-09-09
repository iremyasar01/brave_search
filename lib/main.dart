import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/data/datasources/local/local_data_source.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';
import 'package:brave_search/presentations/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection.dart';
import 'core/network/cubit/network_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'presentations/browser/cubit/browser_cubit.dart';
import 'presentations/web/cubit/web_search_cubit.dart';
import 'presentations/history/cubit/history_cubit.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
 await Hive.initFlutter();
  // Adapter'ları kaydet
  Hive.registerAdapter(SearchHistoryItemAdapter());
  Hive.registerAdapter(TabDataAdapter());
  
  await _initializeApp();
  
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  configureDependencies();
  
  // LocalDataSource'i başlat
  await getIt<LocalDataSource>().init();
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