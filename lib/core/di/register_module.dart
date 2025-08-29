import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';


@module
abstract class RegisterModule {
  @singleton
  Dio get dio {
    final apiKey = dotenv.env['BRAVE_API_KEY'];
    return Dio(BaseOptions(
      baseUrl: 'https://api.search.brave.com/res/v1',
      headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip',
        'X-Subscription-Token': apiKey,
      },
    ));
  }}

