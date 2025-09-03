import '../../core/utils/result.dart';
import '../entities/video_search_result.dart';

abstract class VideoSearchRepository {
  Future<Result<List<VideoSearchResult>>> searchVideos(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}