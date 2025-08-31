import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/video_search_result.dart';

abstract class VideoSearchRemoteDataSource {
  Future<List<VideoSearchResult>> searchVideos(
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
  Future<List<VideoSearchResult>> searchVideos(
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
        '/videos/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final videoResults = data['results'] as List<dynamic>? ?? [];
        return videoResults.map((json) => _parseVideoResult(json)).toList();
      } else {
        throw Exception('Video arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Video arama hatası: $e');
    }
  }

  VideoSearchResult _parseVideoResult(Map<String, dynamic> json) {
    final videoData = json['video'] as Map<String, dynamic>? ?? {};
    final thumbnailData = json['thumbnail'] as Map<String, dynamic>? ?? {};
    
    return VideoSearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      age: json['age'] ?? '',
      duration: videoData['duration'] ?? '',
      creator: videoData['creator'] ?? '',
      publisher: videoData['publisher'] ?? '',
      thumbnailUrl: thumbnailData['src'] ?? '',
      views: (videoData['views'] as int?) ?? 0,
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