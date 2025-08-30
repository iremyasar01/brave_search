import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/image_search_result.dart';

abstract class ImageSearchRemoteDataSource {
  Future<List<ImageSearchResult>> searchImages(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}

@LazySingleton(as: ImageSearchRemoteDataSource)
class ImageSearchRemoteDataSourceImpl implements ImageSearchRemoteDataSource {
  final Dio dio;

  ImageSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ImageSearchResult>> searchImages(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'q': query,
        'count': count,
        'offset': offset,
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
        return imageResults.map((json) => _parseImageResult(json)).toList();
      } else {
        throw Exception('Görsel arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Görsel arama hatası: $e');
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