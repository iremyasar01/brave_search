import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getErrorMessageByStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek parametreleri';
      case 401:
        return 'Yetkilendirme hatası';
      case 403:
        return 'Erişim reddedildi';
      case 404:
        return 'Servis bulunamadı';
      case 422:
        return 'İstek işlenemedi (geçersiz parametreler)';
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

  static String handleDioError(DioException dioError) {
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
        // DioError'un kendi mesajını kontrol et
        if (dioError.message?.contains('SocketException') == true) {
          return 'İnternet bağlantısı bulunamadı';
        }
        return 'Ağ hatası: ${dioError.message}';
    }
  }

  static String getGenericErrorMessage() {
    return 'Bir hata oluştu. Lütfen daha sonra tekrar deneyin.';
  }
}