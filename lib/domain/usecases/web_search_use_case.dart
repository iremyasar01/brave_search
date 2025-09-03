import 'package:injectable/injectable.dart';

import '../../core/utils/result.dart';
import '../entities/web_search_result.dart';
import '../repositories/web_search_repository.dart';

@injectable
class WebSearchUseCase {
  final WebSearchRepository repository;

  WebSearchUseCase(this.repository);

  Future<Result<List<WebSearchResult>>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    // Sayfa sınırlaması (API offset 0-9 arası)
    if (page < 1 || page > 10) {
      return Result.failure('Sayfa numarası 1-10 arasında olmalıdır');
    }

    // Offset hesapla (sayfa - 1)
    // Sayfa 1 -> offset 0
    // Sayfa 2 -> offset 1
    // ...
    // Sayfa 10 -> offset 9
    final offset = (page - 1).clamp(0, 9);

    return await repository.searchWeb(
      query,
      count: count,
      offset: offset,
      country: country,
      safesearch: safesearch,
    );
  }
}
