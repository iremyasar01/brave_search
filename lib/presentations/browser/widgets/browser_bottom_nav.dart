import 'package:brave_search/common/widgets/bottomnavbar/tab_navigation_bar.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
      try {
        // Clear all search results first
        GetIt.instance<WebSearchCubit>().clearResults();
        GetIt.instance<ImageSearchCubit>().clearResults();
        GetIt.instance<VideoSearchCubit>().clearResults();
        GetIt.instance<NewsSearchCubit>().clearResults();
        
        // Update tab query
        browserCubit.updateTabQuery(currentTabId, query);
        
        // Update search type for the tab
        browserCubit.setSearchType(currentTabId, searchType);
        
        // Update search filter
        browserCubit.setSearchFilter(searchType);
        
        // Add to search history
        browserCubit.addToSearchHistory(currentTabId, query, searchType);
        
        // Perform search based on type
        switch (searchType) {
          case 'web':
            GetIt.instance<WebSearchCubit>().searchWeb(query, forceRefresh: true);
            break;
          case 'images':
            GetIt.instance<ImageSearchCubit>().searchImages(query, forceRefresh: true);
            break;
          case 'videos':
            GetIt.instance<VideoSearchCubit>().searchVideo(query, forceRefresh: true);
            break;
          case 'news':
            GetIt.instance<NewsSearchCubit>().searchNews(query, forceRefresh: true);
            break;
          default:
            // Fallback to web search
            GetIt.instance<WebSearchCubit>().searchWeb(query, forceRefresh: true);
        }
      } catch (e) {
        debugPrint('Error performing search from history: $e');
        // Fallback: at least update the query
        if (browserCubit.state.tabs.isNotEmpty) {
          final fallbackTabId = browserCubit.state.tabs[browserCubit.state.activeTabIndex];
          browserCubit.updateTabQuery(fallbackTabId, query);
        }
      }
    }
  }
}