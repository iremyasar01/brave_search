import '../../core/utils/result.dart';
import '../entities/web_search_result.dart';

abstract class WebSearchRepository {
  Future<Result<List<WebSearchResult>>> searchWeb(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}