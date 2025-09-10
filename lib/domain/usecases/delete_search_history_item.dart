import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';

@injectable
class DeleteSearchHistoryItem {
  final LocalRepository _localRepository;

  DeleteSearchHistoryItem(this._localRepository);

  Future<void> call(SearchHistoryItem itemToDelete) async {
    final allHistory = await _localRepository.getSearchHistory();
    
    // Silinecek öğeyi bul ve çıkar
    final updatedHistory = allHistory.where((item) => 
      !(item.query == itemToDelete.query && 
        item.timestamp == itemToDelete.timestamp &&
        item.searchType == itemToDelete.searchType)
    ).toList();
    
    // Tüm geçmişi temizle
    await _localRepository.clearSearchHistory();
    
    // Güncellenmiş listeyi yeniden kaydet
    for (final item in updatedHistory) {
      await _localRepository.saveSearchHistory(item);
    }
  }
}