import 'package:injectable/injectable.dart';
import '../../domain/entities/news_search_result.dart';
import '../../domain/repositories/news_search_repository.dart';
import '../datasources/remote/news_search_remote_data_source.dart';

@LazySingleton(as: NewsSearchRepository)
class NewsSearchRepositoryImpl implements NewsSearchRepository {
  final NewsSearchRemoteDataSource remoteDataSource;

  NewsSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsSearchResult>> searchNews(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  }) {
    return remoteDataSource.searchNews(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}