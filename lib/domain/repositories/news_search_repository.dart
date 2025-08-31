import '../entities/news_search_result.dart';

abstract class NewsSearchRepository {
  Future<List<NewsSearchResult>> searchNews(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}