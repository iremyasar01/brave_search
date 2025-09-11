import 'package:brave_search/common/widgets/bottomnavbar/tab_navigation_bar.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/browser_header.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BrowserBottomNav extends StatelessWidget {
  const BrowserBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        final browserCubit = context.read<BrowserCubit>();

        return TabNavigationBar(
          selectedIndex: browserState.activeTabIndex,
          onTabTapped: (index) => browserCubit.switchTab(index),
          onAddTab: () => browserCubit.addTab(),
          // Fixed: Now using the correct signature (String query, String searchType)
          onSearchFromHistory: (query, searchType) => _onSearchFromHistory(context, query, searchType),
        );
      },
    );
  }

 void _onSearchFromHistory(BuildContext context, String query, String searchType) {
  final browserCubit = context.read<BrowserCubit>();
  final currentTabId = browserCubit.activeTabId;
  
  if (currentTabId != null) {
    // Clear results
    _clearAllSearchResults(context);
    
    // Update tab state
    browserCubit.updateTabQuery(currentTabId, query);
    browserCubit.setSearchType(currentTabId, searchType);
    browserCubit.setSearchFilter(searchType);
    browserCubit.addToSearchHistory(currentTabId, query, searchType);
    
    // Execute search
    SearchActions.performSearch(
      context: context,
      query: query,
      currentFilter: searchType,
      forceRefresh: true,
    );
  }
  
}
void _clearAllSearchResults(BuildContext context) {
  context.read<WebSearchCubit>().clearResults();
  context.read<ImageSearchCubit>().clearResults();
  context.read<VideoSearchCubit>().clearResults();
  context.read<NewsSearchCubit>().clearResults();
}
}