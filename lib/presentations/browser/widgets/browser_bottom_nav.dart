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
          onSearchFromHistory: (query) => _handleSearchFromHistory(context, query),
        );
      },
    );
  }

  void _handleSearchFromHistory(BuildContext context, String query) {
    final browserCubit = context.read<BrowserCubit>();
    
    if (browserCubit.state.tabs.isNotEmpty) {
      final currentTabId = browserCubit.state.tabs[browserCubit.state.activeTabIndex];
      browserCubit.updateTabQuery(currentTabId, query);
    }
    
    final currentFilter = browserCubit.state.searchFilter;
    
    switch (currentFilter) {
      case 'all':
      case 'web':
        GetIt.instance<WebSearchCubit>().searchWeb(query);
        break;
      case 'images':
        GetIt.instance<ImageSearchCubit>().searchImages(query);
        break;
      case 'videos':
        GetIt.instance<VideoSearchCubit>().searchVideo(query);
        break;
      case 'news':
        GetIt.instance<NewsSearchCubit>().searchNews(query);
        break;
      default:
        GetIt.instance<WebSearchCubit>().searchWeb(query);
    }
  }
}