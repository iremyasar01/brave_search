import 'package:brave_search/core/utils/result.dart';
import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:brave_search/domain/repositories/image_search_repository.dart';
import 'package:injectable/injectable.dart';
@injectable
class ImageSearchUseCase {
  final ImageSearchRepository repository;

  ImageSearchUseCase(this.repository);

  Future<Result<List<ImageSearchResult>>> execute(
    String query, {
    int count = 50, // Maksimum 50 çekiyoruz
    String? country,
    String safesearch = 'strict',
  }) async {
    // Offset kullanmadan, direkt count ile istek yapıyoruz
    return await repository.searchImages(
      query,
      count: count, // API'nin izin verdiği maksimum değer (50)
      country: country,
      safesearch: safesearch,
    );
  }
}