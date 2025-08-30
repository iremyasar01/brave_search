import '../entities/image_search_result.dart';

abstract class ImageSearchRepository {
  Future<List<ImageSearchResult>> searchImages(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}