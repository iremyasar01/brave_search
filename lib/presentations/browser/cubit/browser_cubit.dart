import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'browser_state.dart';

@injectable
class BrowserCubit extends Cubit<BrowserState> {
  BrowserCubit() : super(const BrowserState()) {
    // Başlangıçta bir sekme oluştur
    _initializeWithDefaultTab();
  }

  void _initializeWithDefaultTab() {
    final defaultTabId = 'tab_${DateTime.now().millisecondsSinceEpoch}';
    emit(state.copyWith(
      tabs: [defaultTabId],
      activeTabIndex: 0,
      tabQueries: {defaultTabId: ''},
      hasSearched: {defaultTabId: false},
    ));
  }

  void addTab() {
    final newTabId = 'tab_${DateTime.now().millisecondsSinceEpoch}';
    final updatedTabs = List.of(state.tabs)..add(newTabId);
    final updatedQueries = Map.of(state.tabQueries);
    final updatedHasSearched = Map.of(state.hasSearched);
    
    // Yeni sekme için boş sorgu ve arama yapılmamış durumu ekle
    updatedQueries[newTabId] = '';
    updatedHasSearched[newTabId] = false;
    
    emit(state.copyWith(
      tabs: updatedTabs,
      activeTabIndex: updatedTabs.length - 1, // Son eklenen sekmeyi aktif yap
      tabQueries: updatedQueries,
      hasSearched: updatedHasSearched,
    ));
  }

  void closeTab(int index) {
    if (state.tabs.length <= 1) {
      debugPrint('Son sekme, kapatılmıyor');
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

    emit(state.copyWith(
      tabs: tabs,
      activeTabIndex: newActiveIndex,
      tabResults: tabResults,
      tabQueries: tabQueries,
    ));
  }

  void switchTab(int index) {
    if (index >= 0 && index < state.tabs.length && index != state.activeTabIndex) {
      emit(state.copyWith(activeTabIndex: index));
    }
  }

  void setSearchFilter(String filter) {
    // Filtre değiştiğinde mevcut sonuçları temizleme, sadece filtreyi güncelle
    emit(state.copyWith(searchFilter: filter));
  }

  void updateTabResults(String tabId, List<WebSearchResult> results) {
    final tabResults = Map.of(state.tabResults);
    tabResults[tabId] = results;
    emit(state.copyWith(tabResults: tabResults));
  }

  void updateTabQuery(String tabId, String query) {
    final tabQueries = Map.of(state.tabQueries);
    
    if (tabQueries[tabId] != query) {
      tabQueries[tabId] = query;
      emit(state.copyWith(tabQueries: tabQueries));
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

  // Aktif sekmenin sonuçlarını almak için yardımcı metod
  List<WebSearchResult> get activeTabResults {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.tabResults[tabId] ?? [];
    }
    return [];
  }

  // Arama yapıldığını işaretle
  void markTabAsSearched(String tabId) {
    final updatedHasSearched = Map.of(state.hasSearched);
    updatedHasSearched[tabId] = true;
    emit(state.copyWith(hasSearched: updatedHasSearched));
  }

  // Aktif sekmenin arama durumunu al
  bool get activeTabHasSearched {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.hasSearched[tabId] ?? false;
    }
    return false;
  }
}