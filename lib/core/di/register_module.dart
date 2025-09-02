import 'package:brave_search/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  Dio get dio {
    final apiKey = dotenv.env['BRAVE_API_KEY'];
    return Dio(BaseOptions(
      baseUrl: ApiConstants.braveApiBaseUrl,
      headers: {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip',
        'X-Subscription-Token': apiKey,
      },
    ));
  }
}
