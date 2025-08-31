import '../entities/video_search_result.dart';

abstract class VideoSearchRepository {
  Future<List<VideoSearchResult>> searchVideos(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}
