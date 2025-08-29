import 'package:brave_search/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class DioService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.braveApiBaseUrl,
  ));

  static void setup() {
    GetIt.I.registerSingleton<Dio>(_dio);
  }

  static Dio get dio => _dio;
}