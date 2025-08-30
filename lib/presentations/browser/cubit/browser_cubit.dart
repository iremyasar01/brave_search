import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'browser_state.dart';

@injectable
class BrowserCubit extends Cubit<BrowserState> {
  BrowserCubit() : super(const BrowserState()) {
   // debugPrint('🟢 BrowserCubit oluşturuldu');
  }

  void addTab() {
    //debugPrint('🔥 addTab() çağrıldı');
    //debugPrint('🔥 Mevcut sekme sayısı: ${state.tabs.length}');
    
    final newTabId = 'tab_${DateTime.now().millisecondsSinceEpoch}';
    final updatedTabs = List.of(state.tabs)..add(newTabId);
    final updatedQueries = Map.of(state.tabQueries);
    
    // Yeni sekme için boş sorgu ekle
    updatedQueries[newTabId] = '';
    

    
    emit(state.copyWith(
      tabs: updatedTabs,
      activeTabIndex: updatedTabs.length - 1, // Son eklenen sekmeyi aktif yap
      tabQueries: updatedQueries,
    ));
    
   // debugPrint('🔥 State güncellendi. Yeni sekme sayısı: ${state.tabs.length}');
    //debugPrint('🔥 Aktif sekme index: ${state.activeTabIndex}');
  }

  void closeTab(int index) {
   // debugPrint('🔥 closeTab($index) çağrıldı');
    if (state.tabs.length <= 1) {
      debugPrint('🔥 Son sekme, kapatılmıyor');
      return;
    }

    final tabs = List.of(state.tabs);
    final tabId = tabs[index];
    tabs.removeAt(index);

    final tabResults = Map.of(state.tabResults);
    final tabQueries = Map.of(state.tabQueries);
    tabResults.remove(tabId);
    tabQueries.remove(tabId);

    int newActiveIndex = state.activeTabIndex;
    if (index <= state.activeTabIndex && state.activeTabIndex > 0) {
      newActiveIndex = state.activeTabIndex - 1;
    } else if (index < state.activeTabIndex) {
      newActiveIndex = state.activeTabIndex - 1;
    } else if (index == state.activeTabIndex && index >= tabs.length) {
      newActiveIndex = tabs.length - 1;
    }

    debugPrint('🔥 Sekme kapatıldı. Yeni aktif index: $newActiveIndex');

    emit(state.copyWith(
      tabs: tabs,
      activeTabIndex: newActiveIndex,
      tabResults: tabResults,
      tabQueries: tabQueries,
    ));
  }

  void switchTab(int index) {
    debugPrint('🔥 switchTab($index) çağrıldı');
    if (index >= 0 && index < state.tabs.length && index != state.activeTabIndex) {
      emit(state.copyWith(activeTabIndex: index));
      debugPrint('🔥 Aktif sekme değiştirildi: $index');
    }
  }

  void setSearchFilter(String filter) {
    debugPrint('🔥 setSearchFilter($filter) çağrıldı');
    emit(state.copyWith(searchFilter: filter));
  }

  void updateTabResults(String tabId, List<WebSearchResult> results) {
    debugPrint('🔥 updateTabResults çağrıldı - Tab: $tabId, Sonuç sayısı: ${results.length}');
    final tabResults = Map.of(state.tabResults);
    tabResults[tabId] = results;
    emit(state.copyWith(tabResults: tabResults));
  }

  void updateTabQuery(String tabId, String query) {
    debugPrint('🔥 updateTabQuery çağrıldı - Tab: $tabId, Query: $query');
    final tabQueries = Map.of(state.tabQueries);
    
    if (tabQueries[tabId] != query) {
      tabQueries[tabId] = query;
      emit(state.copyWith(tabQueries: tabQueries));
      debugPrint('🔥 Tab query güncellendi');
    }
  }

  // Aktif sekmenin ID'sini almak için yardımcı metod
  String? get activeTabId {
    if (state.tabs.isNotEmpty && state.activeTabIndex < state.tabs.length) {
      return state.tabs[state.activeTabIndex];
    }
    return null;
  }

  // Aktif sekmenin sorgusunu almak için yardımcı metod
  String get activeTabQuery {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.tabQueries[tabId] ?? '';
    }
    return '';
  }
}