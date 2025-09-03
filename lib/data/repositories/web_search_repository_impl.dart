import 'package:injectable/injectable.dart';

import '../../../core/utils/result.dart';
import '../../../domain/entities/web_search_result.dart';
import '../../../domain/repositories/web_search_repository.dart';
import '../datasources/remote/web_search_remote_data_source.dart';

@LazySingleton(as: WebSearchRepository)
class WebSearchRepositoryImpl implements WebSearchRepository {
  final WebSearchRemoteDataSource remoteDataSource;

  WebSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<WebSearchResult>>> searchWeb(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) async {
    return await remoteDataSource.searchWeb(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}