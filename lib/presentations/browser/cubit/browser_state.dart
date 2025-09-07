import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:equatable/equatable.dart';

// Tarayıcı durum sınıfı
class BrowserState extends Equatable {
  final List<String> tabs; // Açık sekmelerin ID listesi
  final int activeTabIndex; // Aktif sekme indeksi
  final Map<String, List<WebSearchResult>> tabWebResults; // Sekmelere göre web sonuçları
  final Map<String, List<NewsSearchResult>> tabNewsResults; // Sekmelere göre haber sonuçları
  final Map<String, String> tabQueries; // Sekmelere göre arama sorguları
  final String searchFilter; // Arama filtresi: 'all', 'web', 'images', 'videos', 'news'
  final bool isSecure; // Güvenli bağlantı durumu
  final Map<String, bool> hasSearched; // Sekmelerde arama yapılıp yapılmadığı
  final Map<String, String> searchTypes; // Sekmelere göre arama türleri

  const BrowserState({
    this.tabs = const [],
    this.activeTabIndex = 0,
    this.tabWebResults = const {},
    this.tabNewsResults = const {},
    this.tabQueries = const {},
    this.searchFilter = 'all',
    this.isSecure = true,
    this.hasSearched = const {},
    this.searchTypes = const {},
  });

  // State kopyalama metodu
  BrowserState copyWith({
    List<String>? tabs,
    int? activeTabIndex,
    Map<String, List<WebSearchResult>>? tabWebResults,
    Map<String, List<NewsSearchResult>>? tabNewsResults,
    Map<String, String>? tabQueries,
    String? searchFilter,
    bool? isSecure,
    Map<String, bool>? hasSearched,
    Map<String, String>? searchTypes,
  }) {
    return BrowserState(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      tabWebResults: tabWebResults ?? this.tabWebResults,
      tabNewsResults: tabNewsResults ?? this.tabNewsResults,
      tabQueries: tabQueries ?? this.tabQueries,
      searchFilter: searchFilter ?? this.searchFilter,
      isSecure: isSecure ?? this.isSecure,
      hasSearched: hasSearched ?? this.hasSearched,
      searchTypes: searchTypes ?? this.searchTypes,
    );
  }

  @override
  List<Object?> get props => [
        tabs,
        activeTabIndex,
        tabWebResults,
        tabNewsResults,
        tabQueries,
        searchFilter,
        isSecure,
        hasSearched,
        searchTypes,
      ];
}