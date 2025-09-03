import 'package:injectable/injectable.dart';

import '../../core/utils/result.dart';
import '../../domain/entities/news_search_result.dart';
import '../../domain/repositories/news_search_repository.dart';

@injectable
class NewsSearchUseCase {
  final NewsSearchRepository repository;

  NewsSearchUseCase(this.repository);

  Future<Result<List<NewsSearchResult>>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    final offset = (page - 1) * count;
    
    return await repository.searchNews(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}