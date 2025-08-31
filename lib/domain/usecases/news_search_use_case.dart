import 'package:injectable/injectable.dart';
import '../entities/news_search_result.dart';
import '../repositories/news_search_repository.dart';

@injectable
class NewsSearchUseCase {
  final NewsSearchRepository repository;

  NewsSearchUseCase(this.repository);

  Future<List<NewsSearchResult>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    final offset = (page - 1) * count;
    
    return repository.searchNews(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}