import '../../core/utils/result.dart';
import '../entities/news_search_result.dart';

abstract class NewsSearchRepository {
  Future<Result<List<NewsSearchResult>>> searchNews(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}