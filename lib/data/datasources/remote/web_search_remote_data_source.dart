import '../../../domain/entities/web_search_result.dart';

abstract class WebSearchRemoteDataSource {
  Future<List<WebSearchResult>> searchWeb(
    String query, {
    int count = 20,
    int offset = 0,
    String? country,
    String safesearch = 'strict',
  });
}