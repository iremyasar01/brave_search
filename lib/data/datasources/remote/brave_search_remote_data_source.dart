/*
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/search_result.dart';

abstract class BraveSearchRemoteDataSource {
  Future<List<SearchResult>> searchWeb(String query, {int page = 1});
  Future<List<SearchResult>> searchImages(String query, {int page = 1});
  Future<List<SearchResult>> searchNews(String query, {int page = 1});
  Future<List<SearchResult>> searchVideos(String query, {int page = 1});
}

@LazySingleton(as: BraveSearchRemoteDataSource)
class BraveSearchRemoteDataSourceImpl implements BraveSearchRemoteDataSource {
  final Dio dio;

  BraveSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SearchResult>> searchWeb(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/web/search',
        queryParameters: {
          'q': query,
          'count': 20,
          'offset': (page - 1) * 20,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final webResults = data['web']?['results'] as List<dynamic>? ?? [];
        return webResults.map((json) => _parseSearchResult(json)).toList();
      } else {
        throw Exception('Web arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Web arama hatası: $e');
    }
  }

  @override
  Future<List<SearchResult>> searchImages(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/images/search',
        queryParameters: {
          'q': query,
          'count': 20,
          'offset': (page - 1) * 20,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final imageResults = data['results'] as List<dynamic>? ?? [];
        return imageResults.map((json) => _parseSearchResult(json)).toList();
      } else {
        throw Exception('Görsel arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Görsel arama hatası: $e');
    }
  }

  @override
  Future<List<SearchResult>> searchNews(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/news/search',
        queryParameters: {
          'q': query,
          'count': 20,
          'offset': (page - 1) * 20,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newsResults = data['news']?['results'] as List<dynamic>? ?? [];
        return newsResults.map((json) => _parseSearchResult(json)).toList();
      } else {
        throw Exception('Haber arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Haber arama hatası: $e');
    }
  }

  @override
  Future<List<SearchResult>> searchVideos(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/videos/search',
        queryParameters: {
          'q': query,
          'count': 20,
          'offset': (page - 1) * 20,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final videoResults = data['videos']?['results'] as List<dynamic>? ?? [];
        return videoResults.map((json) => _parseSearchResult(json)).toList();
      } else {
        throw Exception('Video arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Video arama hatası: $e');
    }
  }

  SearchResult _parseSearchResult(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      favicon: json['profile']?['img'] ?? json['favicon'],
      type: json['type'],
      thumbnail: json['thumbnail']?['url'] ?? json['thumbnail']?['src'],
    );
  }
}
*/