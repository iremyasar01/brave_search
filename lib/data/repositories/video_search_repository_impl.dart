import 'package:injectable/injectable.dart';

import '../../../core/utils/result.dart';
import '../../../domain/entities/video_search_result.dart';
import '../../../domain/repositories/video_search_repository.dart';
import '../datasources/remote/video_search_remote_data_source.dart';

@LazySingleton(as: VideoSearchRepository)
class VideoSearchRepositoryImpl implements VideoSearchRepository {
  final VideoSearchRemoteDataSource remoteDataSource;

  VideoSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<VideoSearchResult>>> searchVideos(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) async {
    return await remoteDataSource.searchVideos(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}