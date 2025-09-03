import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/search_filters.dart';
import 'package:brave_search/presentations/images/views/images_results_view.dart';
import 'package:brave_search/presentations/news/view/news_results_view.dart';
import 'package:brave_search/presentations/videos/views/videos_results_view.dart';
import 'package:brave_search/presentations/web/views/web_results_view.dart';
import 'package:brave_search/presentations/web/widgets/web_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../web/cubit/web_search_cubit.dart';
import '../../web/cubit/web_search_state.dart';
import '../widgets/empty_browser_state.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

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
    if (browserState.searchFilter == 'images') {
      return const ImagesResultsView();
    } else if (browserState.searchFilter == 'videos') {
      return const VideosResultsView();
    } else if (browserState.searchFilter == 'news') {
      return const NewsResultsView();
    }  else {
      return const WebResultsView();
    }
  }

  Widget _buildWebResults(BuildContext context, BrowserState browserState) {
    final theme = Theme.of(context);
    
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case WebSearchStatus.initial:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search, 
                    size: 64, 
                    color: theme.iconTheme.color?.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Arama yapmak için üstteki çubuğu kullanın',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          case WebSearchStatus.loading:
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          case WebSearchStatus.empty:
            return Center(
              child: Text(
                'Sonuç bulunamadı',
                style: theme.textTheme.bodyMedium,
              ),
            );
          case WebSearchStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: theme.colorScheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Bir hata oluştu',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? '',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          case WebSearchStatus.success:
            if (state.results.isEmpty) {
              return Center(
                child: Text(
                  'Hiç sonuç bulunamadı',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.results.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(color: theme.primaryColor),
                    ),
                  );
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: WebSearchResultItem(result: state.results[index]),
                );
              },
            );
        }
      },
    );
  }
}