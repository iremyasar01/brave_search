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
        options: Options(
          validateStatus: (status) {
            // 422 hatasını da normal bir yanıt olarak kabul et
            return status! < 500;
          },
        ),
      );

      // HTTP durum koduna göre işlem
      if (response.statusCode == 200) {
        return _handleSuccessResponse(response);
      } else if (response.statusCode == 422) {
        return _handle422Error(response);
      } else {
        return Result.failure(_getErrorMessageByStatusCode(response.statusCode));
      }
    } on DioException catch (dioError) {
      return Result.failure(_handleDioError(dioError));
    } catch (e) {
      return Result.failure('Beklenmeyen hata: ${e.toString()}');
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

  Result<List<VideoSearchResult>> _handle422Error(Response response) {
    // 422 hatasının detaylarını analiz et
    final errorData = response.data;
    String errorMessage = 'İstek işlenemedi';
    
    if (errorData is Map<String, dynamic>) {
      errorMessage = errorData['message']?.toString() ?? 
                   errorData['error']?.toString() ?? 
                   errorMessage;
    }
    
    return Result.failure('API hatası: $errorMessage');
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
