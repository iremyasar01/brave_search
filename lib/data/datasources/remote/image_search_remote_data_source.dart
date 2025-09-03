import 'package:brave_search/core/errors/api_error_handler.dart';
import 'package:brave_search/core/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/image_search_result.dart';

abstract class ImageSearchRemoteDataSource {
  Future<Result<List<ImageSearchResult>>> searchImages(
    String query, {
    int count = 50,
    String? country,
    String safesearch = 'strict',
  });
}

@LazySingleton(as: ImageSearchRemoteDataSource)
class ImageSearchRemoteDataSourceImpl implements ImageSearchRemoteDataSource {
  final Dio dio;

  ImageSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<Result<List<ImageSearchResult>>> searchImages(
    String query, {
    int count = 50,
    String? country,
    String safesearch = 'strict',
  }) async {
    try {
      // Input validation
      if (query.trim().isEmpty) {
        return Result.failure('Arama sorgusu boş olamaz');
      }
      
      if (count <= 0 || count > 50) {
        return Result.failure('Sayı değeri 1-50 arasında olmalıdır');
      }

      final queryParameters = <String, dynamic>{
        'q': query.trim(),
        'count': count,
        'safesearch': safesearch,
      };

      if (country != null) {
        queryParameters['country'] = country;
      }

      final response = await dio.get(
        '/images/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data == null) {
          return Result.failure('Sunucudan boş yanıt alındı');
        }
        
        final imageResults = data['results'] as List<dynamic>? ?? [];
        
        if (imageResults.isEmpty) {
          return Result.success([]);
        }
        
        try {
          final results = imageResults
              .map((json) => _parseImageResult(json))
              .whereType<ImageSearchResult>()
              .toList();
          
          return Result.success(results);
        } catch (e) {
          return Result.failure('Veri ayrıştırma hatası: ${e.toString()}');
        }
      } else {
        // Merkezi hata yönetimi sınıfını kullan
        return Result.failure(
          ApiErrorHandler.getErrorMessageByStatusCode(response.statusCode)
        );
      }
    } on DioException catch (dioError) {
      // Merkezi hata yönetimi sınıfını kullan
      return Result.failure(
        ApiErrorHandler.handleDioError(dioError)
      );
    } catch (e) {
      // Merkezi hata yönetimi sınıfını kullan
      return Result.failure(
        ApiErrorHandler.getGenericErrorMessage()
      );
    }
  }

  ImageSearchResult _parseImageResult(Map<String, dynamic> json) {
    return ImageSearchResult(
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      imageUrl: json['properties']?['url']?.toString() ?? '',
      thumbnailUrl: json['thumbnail']?['src']?.toString() ?? '',
      width: (json['properties']?['width'] as int?) ?? 0,
      height: (json['properties']?['height'] as int?) ?? 0,
      pageFetched: json['page_fetched']?.toString(),
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
}