import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/initial/search_initial_state.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:brave_search/presentations/web/widgets/web_search_pagination_control.dart';
import 'package:brave_search/presentations/web/widgets/web_search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/web_search_cubit.dart';
import '../cubit/web_search_state.dart';


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

            // Sayfa navigasyonu
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
        return const SearchInitialWidget(message:WebSearchStrings.webInitialMessage);
      case WebSearchStatus.loading:
        return const AppLoadingIndicator();
      case WebSearchStatus.empty:
        return const AppEmptyState(
            message: WebSearchStrings.webEmptyMessage, icon: Icons.search_off);
      case WebSearchStatus.failure:
        return WebSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<WebSearchCubit>().searchWeb(state.query),
        );
      case WebSearchStatus.success:
        return state.results.isEmpty
            ? const AppEmptyState(
                message: WebSearchStrings.webEmptyMessage, icon: Icons.search_off)
            : WebSearchResultsList(results: state.results);
    }
  }
}
