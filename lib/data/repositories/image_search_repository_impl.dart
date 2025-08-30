import 'package:injectable/injectable.dart';

import '../../domain/entities/image_search_result.dart';
import '../../domain/repositories/image_search_repository.dart';
import '../datasources/remote/image_search_remote_data_source.dart';

@LazySingleton(as: ImageSearchRepository)
class ImageSearchRepositoryImpl implements ImageSearchRepository {
  final ImageSearchRemoteDataSource remoteDataSource;

  ImageSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ImageSearchResult>> searchImages(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) {
    return remoteDataSource.searchImages(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}