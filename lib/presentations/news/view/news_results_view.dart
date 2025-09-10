import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/initial/search_initial_state.dart';
import 'package:brave_search/common/widgets/search/pagination_controls.dart';
import 'package:brave_search/common/widgets/search/search_error_widget.dart';
import 'package:brave_search/common/widgets/search/search_results_list.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:brave_search/presentations/news/widgets/news_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/news_search_cubit.dart';
import '../cubit/news_search_state.dart';

class NewsResultsView extends StatelessWidget {
  final ScrollController? scrollController;
  final ValueNotifier<bool>? paginationVisibilityNotifier;
  const NewsResultsView({super.key, this.scrollController, this.paginationVisibilityNotifier});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsSearchCubit, NewsSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            // Sayfa navigasyonu - sadece success durumunda göster
            if (state.status == NewsSearchStatus.success)
         ValueListenableBuilder<bool>(
                valueListenable: paginationVisibilityNotifier ?? ValueNotifier(false),
                builder: (context, isVisible, child) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isVisible ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: !isVisible,
                      child: GenericPaginationControls(
                        currentPage: state.currentPage,
                        hasReachedMax: state.hasReachedMax,
                        onPageChanged: (page) =>
                            context.read<NewsSearchCubit>().loadPage(page),
                        maxPages: 10,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, NewsSearchState state) {
    switch (state.status) {
      case NewsSearchStatus.initial:
        return const SearchInitialWidget(
            message: NewsSearchStrings.newsInitialMessage);
      case NewsSearchStatus.loading:
        return const AppLoadingIndicator();
      case NewsSearchStatus.empty:
        return const AppEmptyState(
          message: NewsSearchStrings.newsEmptyMessage,
          icon: Icons.newspaper_outlined,
        );
      case NewsSearchStatus.failure:
        return GenericSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () =>
              context.read<NewsSearchCubit>().searchNews(state.query),
        );
      case NewsSearchStatus.success:
        return state.results.isEmpty
            ? const AppEmptyState(
                message: NewsSearchStrings.newsNoResultsMessage,
                icon: Icons.newspaper_outlined,
              )
            : GenericSearchResultsList(
                results: state.results,
                itemBuilder: (result, index) =>
                    NewsSearchResultItem(result: result),
                scrollController: scrollController,
              );
    }
  }
}
