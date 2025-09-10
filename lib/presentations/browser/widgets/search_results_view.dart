import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/search_filters.dart';
import 'package:brave_search/presentations/images/views/images_results_view.dart';
import 'package:brave_search/presentations/news/view/news_results_view.dart';
import 'package:brave_search/presentations/videos/views/videos_results_view.dart';
import 'package:brave_search/presentations/web/views/web_results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/empty_browser_state.dart';

class SearchResultsView extends StatelessWidget {
  final ScrollController? scrollController;
  final ValueNotifier<bool>? headerVisibilityNotifier;

  const SearchResultsView({
    super.key,
    this.scrollController,
    this.headerVisibilityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        final browserCubit = context.read<BrowserCubit>();
        
        if (!browserCubit.activeTabHasSearched) {
          return const EmptyBrowserState();
        }

        return Column(
          children: [
            // Search Filters'ı da visibility notifier ile sarmalayın
            if (headerVisibilityNotifier != null)
              ValueListenableBuilder<bool>(
                valueListenable: headerVisibilityNotifier!,
                builder: (context, isVisible, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: isVisible ? 50 : 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isVisible ? 1.0 : 0.0,
                      child: isVisible ? const SearchFilters() : const SizedBox.shrink(),
                    ),
                  );
                },
              )
            else
              const SearchFilters(),
            Expanded(
              child: _buildResultsContent(context, browserState),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultsContent(BuildContext context, BrowserState browserState) {
    // Scroll controller'ı her result view'a geçirin
    if (browserState.searchFilter == 'images') {
      return ImagesResultsView(scrollController: scrollController);
    } else if (browserState.searchFilter == 'videos') {
      return VideosResultsView(scrollController: scrollController);
    } else if (browserState.searchFilter == 'news') {
      return NewsResultsView(scrollController: scrollController);
    } else {
      return WebResultsView(scrollController: scrollController);
    }
  }
}