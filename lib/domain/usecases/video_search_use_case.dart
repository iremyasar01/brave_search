import 'package:injectable/injectable.dart';

import '../entities/video_search_result.dart';
import '../repositories/video_search_repository.dart';

@injectable
class VideoSearchUseCase {
  final VideoSearchRepository repository;

  VideoSearchUseCase(this.repository);

  Future<List<VideoSearchResult>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    final offset = (page - 1) * count;
    
    return repository.searchVideos(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}