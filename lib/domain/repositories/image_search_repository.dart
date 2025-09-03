import '../entities/image_search_result.dart';

import '../../core/utils/result.dart';

abstract class ImageSearchRepository {
  Future<Result<List<ImageSearchResult>>> searchImages(
    String query, {
    int count = 50, // Sadece count parametresi
    String? country,
    String safesearch = 'strict',
  });
}