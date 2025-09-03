import 'package:brave_search/core/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/image_search_result.dart';

abstract class ImageSearchRemoteDataSource {
  Future<Result<List<ImageSearchResult>>> searchImages(
    String query, {
    int count = 50, // Sadece count parametresi
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
    int count = 50, // Sadece count parametresi
    String? country,
    String safesearch = 'strict',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'q': query,
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
        final imageResults = data['results'] as List<dynamic>? ?? [];
        final results = imageResults
            .map((json) => _parseImageResult(json))
            .whereType<ImageSearchResult>()
            .toList();
        
        return Success(results);
      } else {
        return Failure('HTTP Hatası: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Failure('Ağ Hatası: ${e.message}');
    } catch (e) {
      return Failure('Beklenmeyen Hata: $e');
    }
  }
  ImageSearchResult _parseImageResult(Map<String, dynamic> json) {
    return ImageSearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      source: json['source'] ?? '',
      imageUrl: json['properties']?['url'] ?? '',
      thumbnailUrl: json['thumbnail']?['src'] ?? '',
      width: json['properties']?['width'] ?? 0,
      height: json['properties']?['height'] ?? 0,
      pageFetched: json['page_fetched'],
      metaUrl: _parseMetaUrl(json['meta_url']),
    );
  }

  MetaUrl? _parseMetaUrl(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return MetaUrl(
      scheme: json['scheme'] ?? '',
      netloc: json['netloc'] ?? '',
      hostname: json['hostname'] ?? '',
      favicon: json['favicon'] ?? '',
      path: json['path'] ?? '',
    );
  }
}