import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
//import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/search_result.dart';

//part 'browser_state.dart';

@injectable
class BrowserCubit extends Cubit<BrowserState> {
  BrowserCubit() : super(const BrowserState());

  void addTab() {
    final newTabId = 'tab_${DateTime.now().millisecondsSinceEpoch}';
    emit(state.copyWith(
      tabs: List.of(state.tabs)..add(newTabId),
      activeTabIndex: state.tabs.length,
    ));
  }

  void closeTab(int index) {
    if (state.tabs.length <= 1) return;

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
    }

    emit(state.copyWith(
      tabs: tabs,
      activeTabIndex: newActiveIndex,
      tabResults: tabResults,
      tabQueries: tabQueries,
    ));
  }

  void switchTab(int index) {
    if (index >= 0 && index < state.tabs.length) {
      emit(state.copyWith(activeTabIndex: index));
    }
  }

  void setSearchFilter(String filter) {
    emit(state.copyWith(searchFilter: filter));
  }

  void updateTabResults(String tabId, List<SearchResult> results) {
    final tabResults = Map.of(state.tabResults);
    tabResults[tabId] = results;
    emit(state.copyWith(tabResults: tabResults));
  }

  void updateTabQuery(String tabId, String query) {
    final tabQueries = Map.of(state.tabQueries);
    tabQueries[tabId] = query;
    emit(state.copyWith(tabQueries: tabQueries));
  }
}