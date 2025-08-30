import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:equatable/equatable.dart';



//part of 'browser_cubit.dart';

class BrowserState extends Equatable {
  final List<String> tabs;
  final int activeTabIndex;
  final Map<String, List<WebSearchResult>> tabResults;
  final Map<String, String> tabQueries;
  final String searchFilter; // 'all', 'web', 'news', 'videos', etc.
  final bool isSecure;

  const BrowserState({
    this.tabs = const [],
    this.activeTabIndex = 0,
    this.tabResults = const {},
    this.tabQueries = const {},
    this.searchFilter = 'all',
    this.isSecure = true,
  });

  BrowserState copyWith({
    List<String>? tabs,
    int? activeTabIndex,
    Map<String, List<WebSearchResult>>? tabResults,
    Map<String, String>? tabQueries,
    String? searchFilter,
    bool? isSecure,
  }) {
    return BrowserState(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      tabResults: tabResults ?? this.tabResults,
      tabQueries: tabQueries ?? this.tabQueries,
      searchFilter: searchFilter ?? this.searchFilter,
      isSecure: isSecure ?? this.isSecure,
    );
  }

  @override
  List<Object?> get props => [
        tabs,
        activeTabIndex,
        tabResults,
        tabQueries,
        searchFilter,
        isSecure,
      ];
}