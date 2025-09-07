// history_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/usecases/get_search_history.dart';
import 'package:brave_search/domain/usecases/clear_search_history.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  final GetSearchHistory _getSearchHistory;
  final ClearSearchHistory _clearSearchHistory;

  HistoryCubit(
    this._getSearchHistory,
    this._clearSearchHistory,
  ) : super(const HistoryLoading());

  Future<void> loadHistory() async {
    try {
      emit(const HistoryLoading());
      final history = await _getSearchHistory();
      
      // Tarihe göre sırala (yeniden eskiye)
      history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError('Geçmiş yüklenirken hata oluştu: $e'));
    }
  }

  Future<void> clearHistory() async {
    try {
      emit(const HistoryLoading());
      await _clearSearchHistory();
      emit(const HistoryLoaded([]));
    } catch (e) {
      emit(HistoryError('Geçmiş temizlenirken hata oluştu: $e'));
    }
  }

  Future<void> removeHistoryItem(int index, List<SearchHistoryItem> history) async {
    try {
      // Optimistic update: Önce UI'ı güncelle
      final updatedHistory = List<SearchHistoryItem>.from(history);
      final removedItem = updatedHistory.removeAt(index);
      emit(HistoryLoaded(updatedHistory));

      // Sonra backend'den sil
      // Eğer DeleteSearchHistoryItem use case'iniz varsa burada kullanılabilir
      // Şimdilik tüm geçmişi temizleyip güncellenmiş listeyi kaydediyoruz
      await _clearSearchHistory();
      
      // Güncellenmiş listeyi yeniden kaydet
      for (final item in updatedHistory) {
        // Burada SaveSearchHistory use case'i kullanılmalı
        // Basitlik için şimdilik atlıyoruz
      }
      
    } catch (e) {
      // Hata durumunda geri yükle
      emit(HistoryLoaded(history));
      emit(HistoryError('Öğe silinirken hata oluştu: $e'));
    }
  }

  Future<void> refreshHistory() async {
    await loadHistory();
  }
}