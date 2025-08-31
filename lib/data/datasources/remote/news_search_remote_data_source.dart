import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/news_search_result.dart';

abstract class NewsSearchRemoteDataSource {
  Future<List<NewsSearchResult>> searchNews(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}

@LazySingleton(as: NewsSearchRemoteDataSource)
class NewsSearchRemoteDataSourceImpl implements NewsSearchRemoteDataSource {
  final Dio dio;

  NewsSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NewsSearchResult>> searchNews(
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
        '/news/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newsResults = data['results'] as List<dynamic>? ?? [];
        return newsResults.map((json) => _parseNewsResult(json)).toList();
      } else {
        throw Exception('Haber arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Haber arama hatası: $e');
    }
  }

  NewsSearchResult _parseNewsResult(Map<String, dynamic> json) {
    return NewsSearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      age: json['age'] ?? '',
      pageFetched: json['page_fetched'] ?? '',
      metaUrl: _parseMetaUrl(json['meta_url']),
      thumbnail: _parseThumbnail(json['thumbnail'] ?? {}),
    );
  }

  NewsMetaUrl? _parseMetaUrl(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return NewsMetaUrl(
      scheme: json['scheme'] ?? '',
      netloc: json['netloc'] ?? '',
      hostname: json['hostname'] ?? '',
      favicon: json['favicon'] ?? '',
      path: json['path'] ?? '',
    );
  }

  NewsThumbnail _parseThumbnail(Map<String, dynamic> json) {
    return NewsThumbnail(
      src: json['src'] ?? '',
    );
  }
}