import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/api_error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../../../domain/entities/web_search_result.dart';

abstract class WebSearchRemoteDataSource {
  Future<Result<List<WebSearchResult>>> searchWeb(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}

@LazySingleton(as: WebSearchRemoteDataSource)
class WebSearchRemoteDataSourceImpl implements WebSearchRemoteDataSource {
  final Dio dio;

  WebSearchRemoteDataSourceImpl(this.dio);

  @override
  Future<Result<List<WebSearchResult>>> searchWeb(
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
      
      if (count <= 0 || count > 20) {
        return Result.failure('Sayı değeri 1-20 arasında olmalıdır');
      }

      if (offset < 0 || offset > 9) {
        return Result.failure('Offset değeri 0-9 arasında olmalıdır');
      }

      final queryParameters = <String, dynamic>{
        'q': query.trim(),
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
        
        if (data == null) {
          return Result.failure('Sunucudan boş yanıt alındı');
        }
        
        final webResults = data['web']?['results'] as List<dynamic>? ?? [];
        
        if (webResults.isEmpty) {
          return Result.success([]);
        }
        
        try {
          final parsedResults = webResults
              .map((json) => _parseWebSearchResult(json))
              .whereType<WebSearchResult>()
              .toList();
              
          return Result.success(parsedResults);
        } catch (e) {
          return Result.failure('Veri ayrıştırma hatası: ${e.toString()}');
        }
      } else {
        return Result.failure(
          ApiErrorHandler.getErrorMessageByStatusCode(response.statusCode)
        );
      }
    } on DioException catch (dioError) {
      return Result.failure(
        ApiErrorHandler.handleDioError(dioError)
      );
    } catch (e) {
      return Result.failure(
        ApiErrorHandler.getGenericErrorMessage()
      );
    }
  }

  WebSearchResult _parseWebSearchResult(Map<String, dynamic> json) {
    return WebSearchResult(
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      favicon: json['meta_url']?['favicon']?.toString(),
      language: json['language']?.toString(),
      familyFriendly: json['family_friendly'] ?? true,
      pageAge: json['age']?.toString(),
      profile: _parseProfile(json['profile']),
      metaUrl: _parseMetaUrl(json['meta_url']),
      thumbnail: _parseThumbnail(json['thumbnail']),
      cluster: _parseCluster(json['cluster']),
    );
  }

  WebProfile? _parseProfile(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return WebProfile(
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      longName: json['long_name']?.toString() ?? '',
      img: json['img']?.toString(),
    );
  }

  WebMetaUrl? _parseMetaUrl(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return WebMetaUrl(
      scheme: json['scheme']?.toString() ?? '',
      netloc: json['netloc']?.toString() ?? '',
      hostname: json['hostname']?.toString() ?? '',
      favicon: json['favicon']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  WebThumbnail? _parseThumbnail(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return WebThumbnail(
      src: json['src']?.toString() ?? '',
      original: json['original']?.toString() ?? '',
      logo: json['logo'],
    );
  }

  List<WebCluster>? _parseCluster(List<dynamic>? jsonList) {
    if (jsonList == null) return null;
    
    return jsonList.map((json) => WebCluster(
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      familyFriendly: json['family_friendly'] ?? true,
    )).toList();
  }
}