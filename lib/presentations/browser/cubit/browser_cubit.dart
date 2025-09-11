import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/domain/usecases/delete_tab_data.dart';
import 'package:brave_search/domain/usecases/save_tab_data.dart';
import 'package:brave_search/domain/usecases/get_tab_data.dart';
import 'package:brave_search/domain/usecases/save_search_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'browser_state.dart';

@injectable
class BrowserCubit extends Cubit<BrowserState> {
  final SaveTabData _saveTabData;
  final GetTabData _getTabData;
  final DeleteTabData _deleteTabData;
  final SaveSearchHistory _saveSearchHistory;

  BrowserCubit(
    this._saveTabData,
    this._getTabData,
    this._deleteTabData,
    this._saveSearchHistory,
  ) : super(const BrowserState()) {
    _initialize();
  }

  // Tarayıcıyı başlat - kayıtlı sekmeleri yükle
  Future<void> _initialize() async {
    await _loadSavedTabs();
  }

  // Kayıtlı sekmeleri yükle
  Future<void> _loadSavedTabs() async {
    try {
      final savedTabs = await _getTabData();
      
      if (savedTabs.isNotEmpty) {
        final tabIds = savedTabs.keys.toList();
        final tabQueries = Map<String, String>.fromIterables(
          savedTabs.keys,
          savedTabs.values.map((tab) => tab.query),
        );
        
        final tabWebResults = Map<String, List<WebSearchResult>>.fromIterables(
          savedTabs.keys,
          savedTabs.values.map((tab) => tab.webResults),
        );
        
        final tabNewsResults = Map<String, List<NewsSearchResult>>.fromIterables(
          savedTabs.keys,
          savedTabs.values.map((tab) => tab.newsResults),
        );

        final hasSearched = Map<String, bool>.fromIterables(
          savedTabs.keys,
          savedTabs.values.map((tab) => tab.query.isNotEmpty),
        );
        
        final searchTypes = Map<String, String>.fromIterables(
          savedTabs.keys,
          savedTabs.values.map((tab) => tab.searchType),
        );

        emit(state.copyWith(
          tabs: tabIds,
          activeTabIndex: 0,
          tabQueries: tabQueries,
          tabWebResults: tabWebResults,
          tabNewsResults: tabNewsResults,
          hasSearched: hasSearched,
          searchTypes: searchTypes,
        ));
      } else {
        _initializeWithDefaultTab();
      }
    } catch (e) {
      debugPrint('Error loading saved tabs: $e');
      _initializeWithDefaultTab();
    }
  }

  // Varsayılan sekme ile başlat
  void _initializeWithDefaultTab() {
    final defaultTabId = 'tab_${DateTime.now().millisecondsSinceEpoch}';
    emit(state.copyWith(
      tabs: [defaultTabId],
      activeTabIndex: 0,
      tabQueries: {defaultTabId: ''},
      hasSearched: {defaultTabId: false},
      searchTypes: {defaultTabId: 'web'},
    ));
    
    _saveTabData(TabData(
      tabId: defaultTabId,
      query: '',
      webResults: [],
      newsResults: [],
      lastUpdated: DateTime.now(),
      searchType: 'web',
    ));
  }

  // Yeni sekme ekle
  void addTab() {
    final newTabId = 'tab_${DateTime.now().millisecondsSinceEpoch}';
    final updatedTabs = List.of(state.tabs)..add(newTabId);
    final updatedQueries = Map.of(state.tabQueries);
    final updatedHasSearched = Map.of(state.hasSearched);
    final updatedSearchTypes = Map.of(state.searchTypes);
    
    updatedQueries[newTabId] = '';
    updatedHasSearched[newTabId] = false;
    updatedSearchTypes[newTabId] = 'web';
    
    emit(state.copyWith(
      tabs: updatedTabs,
      activeTabIndex: updatedTabs.length - 1,
      tabQueries: updatedQueries,
      hasSearched: updatedHasSearched,
      searchTypes: updatedSearchTypes,
      searchFilter: 'web',
      // Yeni sekme oluştururken search cubit'leri temizle
      shouldRefreshSearch: true,
    ));
    
    _saveTabData(TabData(
      tabId: newTabId,
      query: '',
      webResults: [],
      newsResults: [],
      lastUpdated: DateTime.now(),
      searchType: 'web',
    ));
  }


  void switchTab(int index) {
    if (index >= 0 && index < state.tabs.length) {
      final tabId = state.tabs[index];
      final tabSearchType = state.searchTypes[tabId] ?? 'web';
      final tabQuery = state.tabQueries[tabId] ?? '';
      
      emit(state.copyWith(
        activeTabIndex: index,
        searchFilter: tabSearchType,
        // Sekme değiştirildiğinde arama yapılması gerektiğini işaretle
        shouldRefreshSearch: tabQuery.isNotEmpty,
        tabSwitched: true,
      ));
    }
  }

  // Sekme kapat
  void closeTab(int index) {
    if (state.tabs.length <= 1) {
      debugPrint('Son sekme, kapatılmıyor');
      return;
    }

    final tabs = List.of(state.tabs);
    final tabId = tabs[index];
    tabs.removeAt(index);

    _deleteTabData(tabId);

    final tabWebResults = Map.of(state.tabWebResults);
    final tabNewsResults = Map.of(state.tabNewsResults);
    final tabQueries = Map.of(state.tabQueries);
    final searchTypes = Map.of(state.searchTypes);
    
    tabWebResults.remove(tabId);
    tabNewsResults.remove(tabId);
    tabQueries.remove(tabId);
    searchTypes.remove(tabId);

    int newActiveIndex = state.activeTabIndex;
    if (index <= state.activeTabIndex && state.activeTabIndex > 0) {
      newActiveIndex = state.activeTabIndex - 1;
    }

    emit(state.copyWith(
      tabs: tabs,
      activeTabIndex: newActiveIndex,
      tabWebResults: tabWebResults,
      tabNewsResults: tabNewsResults,
      tabQueries: tabQueries,
      searchTypes: searchTypes,
    ));
  }

  // Web arama sonuçlarını güncelle
  void updateTabWebResults(String tabId, List<WebSearchResult> results) {
    final tabWebResults = Map.of(state.tabWebResults);
    tabWebResults[tabId] = results;
    
    final updatedHasSearched = Map.of(state.hasSearched);
    updatedHasSearched[tabId] = true;
    
    emit(state.copyWith(
      tabWebResults: tabWebResults,
      hasSearched: updatedHasSearched,
    ));
    
    _saveTabData(TabData(
      tabId: tabId,
      query: state.tabQueries[tabId] ?? '',
      webResults: results,
      newsResults: state.tabNewsResults[tabId] ?? [],
      lastUpdated: DateTime.now(),
      searchType: state.searchTypes[tabId] ?? 'web',
    ));
  }

  // Haber arama sonuçlarını güncelle
  void updateTabNewsResults(String tabId, List<NewsSearchResult> results) {
    final tabNewsResults = Map.of(state.tabNewsResults);
    tabNewsResults[tabId] = results;
    
    final updatedHasSearched = Map.of(state.hasSearched);
    updatedHasSearched[tabId] = true;
    
    emit(state.copyWith(
      tabNewsResults: tabNewsResults,
      hasSearched: updatedHasSearched,
    ));
    
    _saveTabData(TabData(
      tabId: tabId,
      query: state.tabQueries[tabId] ?? '',
      webResults: state.tabWebResults[tabId] ?? [],
      newsResults: results,
      lastUpdated: DateTime.now(),
      searchType: state.searchTypes[tabId] ?? 'news',
    ));
  }

  // Sekme sorgusunu güncelle
  void updateTabQuery(String tabId, String query) {
    final tabQueries = Map.of(state.tabQueries);
    
    if (tabQueries[tabId] != query) {
      tabQueries[tabId] = query;
      
      final updatedHasSearched = Map.of(state.hasSearched);
      updatedHasSearched[tabId] = query.isNotEmpty;
      
      emit(state.copyWith(
        tabQueries: tabQueries,
        hasSearched: updatedHasSearched,
      ));
      
      _saveTabData(TabData(
        tabId: tabId,
        query: query,
        webResults: state.tabWebResults[tabId] ?? [],
        newsResults: state.tabNewsResults[tabId] ?? [],
        lastUpdated: DateTime.now(),
        searchType: state.searchTypes[tabId] ?? 'web',
      ));
    }
  }

  // Arama türünü ayarla
  void setSearchType(String tabId, String type) {
    final searchTypes = Map.of(state.searchTypes);
    searchTypes[tabId] = type;
    emit(state.copyWith(searchTypes: searchTypes));
    
    _saveTabData(TabData(
      tabId: tabId,
      query: state.tabQueries[tabId] ?? '',
      webResults: state.tabWebResults[tabId] ?? [],
      newsResults: state.tabNewsResults[tabId] ?? [],
      lastUpdated: DateTime.now(),
      searchType: type,
    ));
  }

  // Arama geçmişine ekle
  void addToSearchHistory(String tabId, String query, String searchType) {
    _saveSearchHistory(SearchHistoryItem(
      query: query,
      timestamp: DateTime.now(),
      tabId: tabId,
      searchType: searchType,
    ));
  }

  // Arama filtresini ayarla
  void setSearchFilter(String newFilter) {
    emit(state.copyWith(searchFilter: newFilter));
  }

  // Search refresh flag'ini sıfırla
  void resetSearchRefreshFlag() {
    emit(state.copyWith(shouldRefreshSearch: false, shouldClearCache: false, tabSwitched: false));
  }

  // Aktif sekme ID'sini getir
  String? get activeTabId {
    if (state.tabs.isNotEmpty && state.activeTabIndex < state.tabs.length) {
      return state.tabs[state.activeTabIndex];
    }
    return null;
  }

  // Aktif sekme sorgusunu getir
  String get activeTabQuery {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.tabQueries[tabId] ?? '';
    }
    return '';
  }

  // Aktif sekme web sonuçlarını getir
  List<WebSearchResult> get activeTabWebResults {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.tabWebResults[tabId] ?? [];
    }
    return [];
  }

  // Aktif sekme haber sonuçlarını getir
  List<NewsSearchResult> get activeTabNewsResults {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.tabNewsResults[tabId] ?? [];
    }
    return [];
  }

  // Aktif sekme arama türünü getir
  String get activeTabSearchType {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.searchTypes[tabId] ?? 'web';
    }
    return 'web';
  }
  
  // Aktif sekmede arama yapılıp yapılmadığını kontrol et
  bool get activeTabHasSearched {
    final tabId = activeTabId;
    if (tabId != null) {
      return state.hasSearched[tabId] ?? false;
    }
    return false;
  }
}