import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/images/views/images_results_view.dart';
import 'package:brave_search/presentations/web/views/web_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../web/cubit/web_search_cubit.dart';
import '../../web/cubit/web_search_state.dart';
import '../widgets/search_filters.dart';
import '../widgets/empty_browser_state.dart';


class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        final browserCubit = context.read<BrowserCubit>();
        
        // Eğer aktif sekmede arama yapılmamışsa ana sayfa göster
        if (!browserCubit.activeTabHasSearched) {
          return const EmptyBrowserState();
        }

        // Arama yapıldıysa filtreleri ve sonuçları göster
        return Column(
          children: [
            // Search filters - sadece arama yapıldıktan sonra görünür
            const SearchFilters(),
            
            // Search results content
            Expanded(
              child: _buildResultsContent(context, browserState),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultsContent(BuildContext context, BrowserState browserState) {
    // Seçilen filtreye göre farklı görünümler göster
    if (browserState.searchFilter == 'images') {
      return const ImagesResultsView();
    } else if (browserState.searchFilter == 'videos') {
      return _buildVideosResults();
    } else if (browserState.searchFilter == 'news') {
      return _buildNewsResults(context, browserState);
    } else {
      return _buildWebResults(context, browserState);
    }
  }

  Widget _buildWebResults(BuildContext context, BrowserState browserState) {
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case WebSearchStatus.initial:
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'Arama yapmak için üstteki çubuğu kullanın',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          case WebSearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          case WebSearchStatus.empty:
            return const Center(
              child: Text(
                'Sonuç bulunamadı',
                style: TextStyle(color: Colors.white70),
              ),
            );
          case WebSearchStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Bir hata oluştu',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? '',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          case WebSearchStatus.success:
            if (state.results.isEmpty) {
              return const Center(
                child: Text(
                  'Hiç sonuç bulunamadı',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.results.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
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

  Widget _buildNewsResults(BuildContext context, BrowserState browserState) {
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        if (state.status == WebSearchStatus.initial) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.newspaper, color: Colors.white54, size: 48),
                SizedBox(height: 16),
                Text(
                  'Haber aramak için bir sorgu girin',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }
        
        return _buildWebResults(context, browserState);
      },
    );
  }

  Widget _buildVideosResults() {
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        if (state.status == WebSearchStatus.initial) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library, color: Colors.white54, size: 48),
                SizedBox(height: 16),
                Text(
                  'Video aramak için bir sorgu girin',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }
        
        return BlocBuilder<BrowserCubit, BrowserState>(
          builder: (context, browserState) => _buildWebResults(context, browserState),
        );
      },
    );
  }
}