import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';

@injectable
class CleanOldHistory {
  final LocalRepository _localRepository;

  CleanOldHistory(this._localRepository);

  Future<void> call({int daysThreshold = 30}) async {
    final history = await _localRepository.getSearchHistory();
    final threshold = DateTime.now().subtract(Duration(days: daysThreshold));
    
    final recentHistory = history.where((item) => item.timestamp.isAfter(threshold)).toList();
    
    await _localRepository.clearSearchHistory();
    
    for (final item in recentHistory) {
      await _localRepository.saveSearchHistory(item);
    }
  }
}