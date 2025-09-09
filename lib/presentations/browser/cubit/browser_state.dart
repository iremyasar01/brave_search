import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:equatable/equatable.dart';

class BrowserState extends Equatable {
  final List<String> tabs;
  final int activeTabIndex;
  final Map<String, String> tabQueries;
  final Map<String, List<WebSearchResult>> tabWebResults;
  final Map<String, List<NewsSearchResult>> tabNewsResults;
  final Map<String, bool> hasSearched;
  final Map<String, String> searchTypes;
  final String searchFilter;
  
  // Cache yönetimi için yeni field'lar
  final bool shouldRefreshSearch; // Arama yapılması gerektiğini belirtir
  final bool shouldClearCache;    // Cache'in temizlenmesi gerektiğini belirtir
  final bool tabSwitched;         // Sekme değiştirildiğini belirtir

  const BrowserState({
    this.tabs = const [],
    this.activeTabIndex = 0,
    this.tabQueries = const {},
    this.tabWebResults = const {},
    this.tabNewsResults = const {},
    this.hasSearched = const {},
    this.searchTypes = const {},
    this.searchFilter = 'web',
    this.shouldRefreshSearch = false,
    this.shouldClearCache = false,
    this.tabSwitched = false,
  });

  BrowserState copyWith({
    List<String>? tabs,
    int? activeTabIndex,
    Map<String, String>? tabQueries,
    Map<String, List<WebSearchResult>>? tabWebResults,
    Map<String, List<NewsSearchResult>>? tabNewsResults,
    Map<String, bool>? hasSearched,
    Map<String, String>? searchTypes,
    String? searchFilter,
    bool? shouldRefreshSearch,
    bool? shouldClearCache,
    bool? tabSwitched,
  }) {
    return BrowserState(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      tabQueries: tabQueries ?? this.tabQueries,
      tabWebResults: tabWebResults ?? this.tabWebResults,
      tabNewsResults: tabNewsResults ?? this.tabNewsResults,
      hasSearched: hasSearched ?? this.hasSearched,
      searchTypes: searchTypes ?? this.searchTypes,
      searchFilter: searchFilter ?? this.searchFilter,
      shouldRefreshSearch: shouldRefreshSearch ?? this.shouldRefreshSearch,
      shouldClearCache: shouldClearCache ?? this.shouldClearCache,
      tabSwitched: tabSwitched ?? this.tabSwitched,
    );
  }

  @override
  List<Object?> get props => [
        tabs,
        activeTabIndex,
        tabQueries,
        tabWebResults,
        tabNewsResults,
        hasSearched,
        searchTypes,
        searchFilter,
        shouldRefreshSearch,
        shouldClearCache,
        tabSwitched,
      ];
}