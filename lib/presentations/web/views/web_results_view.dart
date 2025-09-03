import 'package:brave_search/presentations/web/widgets/web_search_pagination_control.dart';
import 'package:brave_search/presentations/web/widgets/web_search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../cubit/web_search_cubit.dart';
import '../cubit/web_search_state.dart';

import '../widgets/web_search_initial_widget.dart';
import '../widgets/web_search_loading_widget.dart';
import '../widgets/web_search_empty_widget.dart';
import '../widgets/web_search_error_widget.dart';


class WebResultsView extends StatelessWidget {
  const WebResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            
            // Sayfa navigasyonu (en alta taşındı)
            if (state.status == WebSearchStatus.success)
              WebSearchPaginationControls(state: state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WebSearchState state) {
    switch (state.status) {
      case WebSearchStatus.initial:
        return const WebSearchInitialWidget();
      case WebSearchStatus.loading:
        return const WebSearchLoadingWidget();
      case WebSearchStatus.empty:
        return const WebSearchEmptyWidget();
      case WebSearchStatus.failure:
        return WebSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<WebSearchCubit>().searchWeb(state.query),
        );
      case WebSearchStatus.success:
        return state.results.isEmpty
            ? const WebSearchEmptyWidget()
            : WebSearchResultsList(results: state.results);
    }
  }
}