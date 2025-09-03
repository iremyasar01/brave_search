import 'package:brave_search/core/errors/api_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/result.dart';
import '../../../../domain/entities/video_search_result.dart';

abstract class VideoSearchRemoteDataSource {
  Future<Result<List<VideoSearchResult>>> searchVideos(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}

@LazySingleton(as: VideoSearchRemoteDataSource)
class VideoSearchRemoteDataSourceImpl implements VideoSearchRemoteDataSource {
  final Dio dio;

  VideoSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<Result<List<VideoSearchResult>>> searchVideos(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) async {
    try {
      // Input validation
      if (query.trim().isEmpty) {
        return Result.failure('Arama sorgusu boş olamaz');
      }

      // API sınırlamalarını kontrol et
      if (count <= 0 || count > 20) {
        count = 20; // Varsayılan değere dön
      }

      if (offset < 0) {
        offset = 0; // Minimum değere dön
      }

      // API'nin beklediği parametre formatı
      final queryParameters = <String, dynamic>{
        'q': query.trim(),
        'count': count.toString(),
        'offset': offset.toString(),
        'safesearch': safesearch,
      };

      // Ülke parametresi opsiyonel
      if (country != null && country.isNotEmpty) {
        queryParameters['country'] = country;
      }
      final response = await dio.get(
        '/videos/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return _handleSuccessResponse(response);
      } else {
        return Result.failure(
            ApiErrorHandler.getErrorMessageByStatusCode(response.statusCode));
      }
    } on DioException catch (dioError) {
      return Result.failure(ApiErrorHandler.handleDioError(dioError));
    } catch (e) {
      return Result.failure(ApiErrorHandler.getGenericErrorMessage());
    }
  }
}

Result<List<VideoSearchResult>> _handleSuccessResponse(Response response) {
  final data = response.data;

  if (data == null) {
    return Result.failure('Sunucudan boş yanıt alındı');
  }

  final videoResults = data['results'] as List<dynamic>? ?? [];

  if (videoResults.isEmpty) {
    return Result.success([]);
  }

  try {
    final parsedResults = videoResults
        .map((json) => _parseVideoResult(json))
        .whereType<VideoSearchResult>()
        .toList();

    return Result.success(parsedResults);
  } catch (e) {
    return Result.failure('Veri ayrıştırma hatası: ${e.toString()}');
  }
}

VideoSearchResult _parseVideoResult(Map<String, dynamic> json) {
  final videoData = json['video'] as Map<String, dynamic>? ?? {};
  final thumbnailData = json['thumbnail'] as Map<String, dynamic>? ?? {};

  return VideoSearchResult(
    title: json['title']?.toString() ?? '',
    url: json['url']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    age: json['age']?.toString() ?? '',
    duration: videoData['duration']?.toString() ?? '',
    creator: videoData['creator']?.toString() ?? '',
    publisher: videoData['publisher']?.toString() ?? '',
    thumbnailUrl: thumbnailData['src']?.toString() ?? '',
    views: (videoData['views'] as int?) ?? 0,
    metaUrl: _parseMetaUrl(json['meta_url']),
  );
}

MetaUrl? _parseMetaUrl(Map<String, dynamic>? json) {
  if (json == null) return null;

  return MetaUrl(
    scheme: json['scheme']?.toString() ?? '',
    netloc: json['netloc']?.toString() ?? '',
    hostname: json['hostname']?.toString() ?? '',
    favicon: json['favicon']?.toString() ?? '',
    path: json['path']?.toString() ?? '',
  );
}
