import 'package:injectable/injectable.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/news_search_result.dart';
import '../../domain/repositories/news_search_repository.dart';

@injectable
class NewsSearchUseCase {
  final NewsSearchRepository repository;
  static const int maxAllowedOffset = 9; // Maksimum offset 9

  NewsSearchUseCase(this.repository);

  Future<Result<List<NewsSearchResult>>> execute(
    String query, {
    int page = 1,
    int count = 20,
    String? country,
    String safesearch = 'strict',
  }) async {
    try {
      // Offset hesaplama: page-1 (çünkü offset 0'dan başlar)
      final offset = page - 1;
      
      if (offset > maxAllowedOffset) {
        return Result.failure('Maksimum arama derinliğine ulaşıldı. Daha fazla sonuç gösterilemez.');
      }
      
      return await repository.searchNews(
        query,
        count: count,
        offset: offset,
        country: country,
        safesearch: safesearch,
      );
    } catch (e) {
      return Result.failure('İşlem sırasında bir hata oluştu: ${e.toString()}');
    }
  }
}