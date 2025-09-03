// data/datasources/remote/news_search_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/result.dart';
import '../../../../domain/entities/news_search_result.dart';

abstract class NewsSearchRemoteDataSource {
  Future<Result<List<NewsSearchResult>>> searchNews(
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
  Future<Result<List<NewsSearchResult>>> searchNews(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) async {
    try {
      // Input validation
      if (query.trim().isEmpty) {
        return  Result.failure('Arama sorgusu boş olamaz');
      }
      
      if (count <= 0 || count > 20) {
        return  Result.failure('Sayı değeri 1-20 arasında olmalıdır');
      }

      if (offset < 0 || offset > 9) {
        return  Result.failure('Offset değeri 0-9 arasında olmalıdır');
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
        '/news/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data == null) {
          return  Result.failure('Sunucudan boş yanıt alındı');
        }
        
        final newsResults = data['results'] as List<dynamic>? ?? [];
        
        if (newsResults.isEmpty) {
          return  Result.success([]);
        }
        
        try {
          final parsedResults = newsResults
              .map((json) => _parseNewsResult(json))
              .whereType<NewsSearchResult>()
              .toList();
              
          return Result.success(parsedResults);
        } catch (e) {
          return Result.failure('Veri ayrıştırma hatası: ${e.toString()}');
        }
      } else {
        return Result.failure(_getErrorMessageByStatusCode(response.statusCode));
      }
    } on DioException catch (dioError) {
      return Result.failure(_handleDioError(dioError));
    } catch (e) {
      return Result.failure('Beklenmeyen hata: ${e.toString()}');
    }
  }

  NewsSearchResult _parseNewsResult(Map<String, dynamic> json) {
    return NewsSearchResult(
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      pageFetched: json['page_fetched']?.toString() ?? '',
      metaUrl: _parseMetaUrl(json['meta_url']),
      thumbnail: _parseThumbnail(json['thumbnail'] ?? {}),
    );
  }

  NewsMetaUrl? _parseMetaUrl(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return NewsMetaUrl(
      scheme: json['scheme']?.toString() ?? '',
      netloc: json['netloc']?.toString() ?? '',
      hostname: json['hostname']?.toString() ?? '',
      favicon: json['favicon']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  NewsThumbnail _parseThumbnail(Map<String, dynamic> json) {
    return NewsThumbnail(
      src: json['src']?.toString() ?? '',
    );
  }

  String _getErrorMessageByStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek parametreleri';
      case 401:
        return 'Yetkilendirme hatası';
      case 403:
        return 'Erişim reddedildi';
      case 404:
        return 'Servis bulunamadı';
      case 429:
        return 'Çok fazla istek gönderildi, lütfen bekleyin';
      case 500:
        return 'Sunucu hatası';
      case 502:
        return 'Ağ geçidi hatası';
      case 503:
        return 'Servis geçici olarak kullanılamıyor';
      default:
        return 'HTTP hatası: $statusCode';
    }
  }

  String _handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return 'Bağlantı zaman aşımına uğradı';
      case DioExceptionType.sendTimeout:
        return 'Veri gönderimi zaman aşımına uğradı';
      case DioExceptionType.receiveTimeout:
        return 'Veri alımı zaman aşımına uğradı';
      case DioExceptionType.badCertificate:
        return 'Güvenlik sertifikası hatası';
      case DioExceptionType.cancel:
        return 'İstek iptal edildi';
      case DioExceptionType.connectionError:
        return 'İnternet bağlantısı bulunamadı';
      case DioExceptionType.unknown:
      default:
        return 'Ağ hatası: ${dioError.message}';
    }
  }
}