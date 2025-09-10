import 'package:brave_search/domain/usecases/delete_search_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/usecases/get_search_history.dart';
import 'package:brave_search/domain/usecases/clear_search_history.dart';
import 'package:brave_search/domain/usecases/clean_old_history.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  final GetSearchHistory _getSearchHistory;
  final ClearSearchHistory _clearSearchHistory;
  final CleanOldHistory _cleanOldHistory;
  final DeleteSearchHistoryItem _deleteSearchHistoryItem;

  HistoryCubit(
    this._getSearchHistory,
    this._clearSearchHistory,
    this._cleanOldHistory,
    this._deleteSearchHistoryItem,
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
      // Hata durumunda mevcut durumu geri yükle
      await loadHistory();
    }
  }

  // 30 günden eski kayıtları otomatik temizle
  Future<void> cleanOldHistory({int daysThreshold = 30}) async {
    try {
      await _cleanOldHistory(daysThreshold: daysThreshold);
    } catch (e) {
      // Sessizce hata ver, kullanıcıya gösterme
      debugPrint('Eski geçmiş temizlenirken hata: $e');
    }
  }


  Future<void> removeHistoryItem(int index) async {
    final currentState = state;
    if (currentState is! HistoryLoaded) return;

    try {
      final currentHistory = currentState.history;
      if (index < 0 || index >= currentHistory.length) return;

      final itemToDelete = currentHistory[index];

      // Optimistic update: Remove the item from the list and update the state
      final updatedHistory = List<SearchHistoryItem>.from(currentHistory);
      updatedHistory.removeAt(index);
      emit(HistoryLoaded(updatedHistory));

      // Use the use case to delete the specific item
      await _deleteSearchHistoryItem(itemToDelete);

      // We don't need to reload the entire history because we already updated the UI optimistically
      // However, if you want to ensure consistency, you can reload:
      // await loadHistory();
    } catch (e) {
      emit(HistoryError('Öğe silinirken hata oluştu: $e'));
      // In case of error, reload the history to revert the optimistic update
      await loadHistory();
    }
  }
  Future<void> refreshHistory() async {
    await loadHistory();
  }

  // Arama sonrası geçmişi yenile (eğer başka yerden çağrılırsa)
  Future<void> onSearchPerformed() async {
    if (state is HistoryLoaded) {
      await refreshHistory();
    }
  }
}