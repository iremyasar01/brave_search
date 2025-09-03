import 'package:brave_search/core/utils/result.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/image_search_result.dart';
import '../../domain/repositories/image_search_repository.dart';
import '../datasources/remote/image_search_remote_data_source.dart';

@LazySingleton(as: ImageSearchRepository)
class ImageSearchRepositoryImpl implements ImageSearchRepository {
  final ImageSearchRemoteDataSource remoteDataSource;

  ImageSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<ImageSearchResult>>> searchImages(
    String query, {
    int count = 50, // Sadece count parametresi
    String? country,
    String safesearch = 'strict',
  }) async {
    return await remoteDataSource.searchImages(
      query,
      count: count,
      country: country,
      safesearch: safesearch,
    );
  }
}