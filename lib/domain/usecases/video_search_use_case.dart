import 'package:injectable/injectable.dart';
import '../../core/utils/result.dart';
import '../entities/video_search_result.dart';
import '../repositories/video_search_repository.dart';

@injectable
class VideoSearchUseCase {
  final VideoSearchRepository repository;
  static const int maxAllowedOffset = 9; // Maksimum offset 9

  VideoSearchUseCase(this.repository);

  Future<Result<List<VideoSearchResult>>> execute(
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
      
      return await repository.searchVideos(
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