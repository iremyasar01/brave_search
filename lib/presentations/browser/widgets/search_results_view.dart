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
  }}


