import 'package:injectable/injectable.dart';

import '../entities/web_search_result.dart';
import '../repositories/web_search_repository.dart';

@injectable
class WebSearchUseCase {
  final WebSearchRepository repository;

  WebSearchUseCase(this.repository);

  Future<List<WebSearchResult>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    final offset = (page - 1) * count;
    
    return repository.searchWeb(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}