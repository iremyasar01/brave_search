import 'package:brave_search/app.dart';
import 'package:brave_search/data/datasources/local/local_data_source.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initHive();
  await _initializeApp();

  runApp(const MyApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SearchHistoryItemAdapter());
  Hive.registerAdapter(TabDataAdapter());
}

Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  configureDependencies();
  await getIt<LocalDataSource>().init();
}
