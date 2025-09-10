import 'package:brave_search/core/network/widgets/network_status_banner.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/browser_header.dart';
import 'package:brave_search/presentations/browser/widgets/empty_browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/search_results_view.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BrowserBody extends StatelessWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> headerVisibilityNotifier;
  final ValueNotifier<bool> paginationVisibilityNotifier;

  const BrowserBody({
    super.key,
    required this.scrollController,
    required this.headerVisibilityNotifier,
    required this.paginationVisibilityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrowserCubit, BrowserState>(
      listener: (context, browserState) {
        _handleTabSwitchSearch(context, browserState);
      },
      builder: (context, browserState) {
        final isEmptyState = browserState.tabs.isEmpty ||
            (browserState.tabs.isNotEmpty &&
                context.read<BrowserCubit>().activeTabQuery.isEmpty);

        // Empty state'te header'ı her zaman göster
        if (isEmptyState) {
          headerVisibilityNotifier.value = true;
          paginationVisibilityNotifier.value = false;
        }

        return Column(
          children: [
            const NetworkStatusBanner(),
            // Header visibility kontrolü
            ValueListenableBuilder<bool>(
              valueListenable: headerVisibilityNotifier,
              builder: (context, isHeaderVisible, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isHeaderVisible ? null : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isHeaderVisible ? 1.0 : 0.0,
                    child: isHeaderVisible ? const BrowserHeader() : const SizedBox.shrink(),
                  ),
                );
              },
            ),
            Expanded(
              child: isEmptyState
                  ? const EmptyBrowserState()
                  : SearchResultsView(
                      scrollController: scrollController,
                      headerVisibilityNotifier: headerVisibilityNotifier,
                      paginationVisibilityNotifier: paginationVisibilityNotifier,
                    ),
            ),
          ],
        );
      },
    );
  }

  void _handleTabSwitchSearch(BuildContext context, BrowserState browserState) {
    if (!browserState.shouldRefreshSearch) return;

    final browserCubit = context.read<BrowserCubit>();
    final currentQuery = browserCubit.activeTabQuery;
    if (currentQuery.isEmpty) return;

    if (browserState.shouldClearCache) {
      _clearAllSearchResults(context);
    }

    switch (browserState.searchFilter) {
      case 'all':
      case 'web':
        GetIt.instance<WebSearchCubit>()
            .searchWeb(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
      case 'images':
        GetIt.instance<ImageSearchCubit>()
            .searchImages(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
      case 'videos':
        GetIt.instance<VideoSearchCubit>()
            .searchVideo(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
      case 'news':
        GetIt.instance<NewsSearchCubit>()
            .searchNews(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
    }

    browserCubit.resetSearchRefreshFlag();
  }

  void _clearAllSearchResults(BuildContext context) {
    GetIt.instance<WebSearchCubit>().clearResults();
    GetIt.instance<ImageSearchCubit>().clearResults();
    GetIt.instance<VideoSearchCubit>().clearResults();
    GetIt.instance<NewsSearchCubit>().clearResults();
  }
}