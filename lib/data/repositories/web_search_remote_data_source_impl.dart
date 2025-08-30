import 'package:brave_search/data/datasources/remote/web_search_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/web_search_result.dart';
@LazySingleton(as: WebSearchRemoteDataSource)
class WebSearchRemoteDataSourceImpl implements WebSearchRemoteDataSource {
  final Dio dio;

  WebSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<WebSearchResult>> searchWeb(
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
        '/web/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final webResults = data['web']?['results'] as List<dynamic>? ?? [];
        return webResults.map((json) => _parseWebSearchResult(json)).toList();
      } else {
        throw Exception('Web arama başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Web arama hatası: $e');
    }
  }

  WebSearchResult _parseWebSearchResult(Map<String, dynamic> json) {
    return WebSearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      favicon: json['meta_url']?['favicon'],
      language: json['language'],
      familyFriendly: json['family_friendly'] ?? true,
      pageAge: json['age'],
      profile: _parseProfile(json['profile']),
      metaUrl: _parseMetaUrl(json['meta_url']),
      thumbnail: _parseThumbnail(json['thumbnail']),
      cluster: _parseCluster(json['cluster']),
    );
  }

  WebProfile? _parseProfile(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return WebProfile(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      longName: json['long_name'] ?? '',
      img: json['img'],
    );
  }

  WebMetaUrl? _parseMetaUrl(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return WebMetaUrl(
      scheme: json['scheme'] ?? '',
      netloc: json['netloc'] ?? '',
      hostname: json['hostname'] ?? '',
      favicon: json['favicon'] ?? '',
      path: json['path'] ?? '',
    );
  }

  WebThumbnail? _parseThumbnail(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return WebThumbnail(
      src: json['src'] ?? '',
      original: json['original'] ?? '',
      logo: json['logo'],
    );
  }

  List<WebCluster>? _parseCluster(List<dynamic>? jsonList) {
    if (jsonList == null) return null;
    
    return jsonList.map((json) => WebCluster(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      familyFriendly: json['family_friendly'] ?? true,
    )).toList();
  }
}