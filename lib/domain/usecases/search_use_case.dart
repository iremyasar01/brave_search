/*
import 'package:brave_search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';

import '../entities/search_result.dart';


@injectable
class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<List<SearchResult>> execute(
    String query, {
    String searchType = 'web',
    int page = 1,
  }) async {
    switch (searchType) {
      case 'images':
        return repository.searchImages(query, page: page);
      case 'news':
        return repository.searchNews(query, page: page);
      case 'videos':
        return repository.searchVideos(query, page: page);
      default:
        return repository.searchWeb(query, page: page);
    }
  }
}
*/