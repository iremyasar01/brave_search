import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/initial/search_initial_state.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:brave_search/presentations/news/widgets/news_result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/news_search_cubit.dart';
import '../cubit/news_search_state.dart';
import '../widgets/news_search_error_widget.dart';
import '../widgets/news_search_pagination_control.dart';


class NewsResultsView extends StatelessWidget {
  const NewsResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsSearchCubit, NewsSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),

            // Sayfa navigasyonu
            if (state.status == NewsSearchStatus.success)
              NewsSearchPaginationControls(state: state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, NewsSearchState state) {
    switch (state.status) {
      case NewsSearchStatus.initial:
        return const SearchInitialWidget(message: NewsSearchStrings.newsInitialMessage);
      case NewsSearchStatus.loading:
        return const AppLoadingIndicator();
      case NewsSearchStatus.empty:
        return const AppEmptyState(
            message: NewsSearchStrings.newsEmptyMessage, icon: Icons.article_outlined);
      case NewsSearchStatus.failure:
        return NewsSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<NewsSearchCubit>().searchNews(state.query),
        );
      case NewsSearchStatus.success:
        return state.results.isEmpty
            ? const AppEmptyState(
                message: NewsSearchStrings.newsEmptyMessage, icon: Icons.article_outlined)
            : NewsSearchResultsList(results: state.results);
    }
  }
}