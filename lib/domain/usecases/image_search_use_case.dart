import 'package:injectable/injectable.dart';

import '../entities/image_search_result.dart';
import '../repositories/image_search_repository.dart';

@injectable
class ImageSearchUseCase {
  final ImageSearchRepository repository;

  ImageSearchUseCase(this.repository);

  Future<List<ImageSearchResult>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    final offset = (page - 1) * count;
    
    return repository.searchImages(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}