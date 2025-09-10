import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/initial/search_initial_state.dart';
import 'package:brave_search/common/widgets/search/pagination_controls.dart';
import 'package:brave_search/common/widgets/search/search_error_widget.dart';
import 'package:brave_search/common/widgets/search/search_results_list.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:brave_search/presentations/web/widgets/web_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/web_search_cubit.dart';
import '../cubit/web_search_state.dart';

class WebResultsView extends StatelessWidget {
  final ScrollController? scrollController; 

  const WebResultsView({
    super.key,
    this.scrollController, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            // Sayfa navigasyonu - sadece success durumunda göster
            if (state.status == WebSearchStatus.success)
              GenericPaginationControls(
                currentPage: state.currentPage,
                hasReachedMax: state.hasReachedMax,
                onPageChanged: (page) =>
                    context.read<WebSearchCubit>().loadPage(page),
                maxPages: 10,
              ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WebSearchState state) {
    switch (state.status) {
      case WebSearchStatus.initial:
        return const SearchInitialWidget(
            message: NewsSearchStrings.newsInitialMessage);
      case WebSearchStatus.loading:
        return const AppLoadingIndicator();
      case WebSearchStatus.empty:
        return const AppEmptyState(
          message: NewsSearchStrings.newsEmptyMessage,
          icon: Icons.web_asset_off_outlined,
        );
      case WebSearchStatus.failure:
        return GenericSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<WebSearchCubit>().searchWeb(state.query),
        );
      case WebSearchStatus.success:
        return state.results.isEmpty
            ? const AppEmptyState(
                message: NewsSearchStrings.newsNoResultsMessage,
                icon: Icons.web_asset_off_outlined,
              )
            : GenericSearchResultsList(
                results: state.results,
                itemBuilder: (result, index) =>
                    WebSearchResultItem(result: result),
                scrollController: scrollController,
            );
    }
}}