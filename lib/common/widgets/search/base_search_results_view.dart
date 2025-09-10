import 'package:brave_search/common/widgets/search/pagination_controls.dart';
import 'package:brave_search/common/widgets/search/search_error_widget.dart';
import 'package:brave_search/common/widgets/search/search_results_list.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../interfaces/base_search_state.dart';
import '../../widgets/initial/search_initial_state.dart';

class BaseSearchResultsView<TState extends BaseSearchState<TResult>, TResult, TCubit extends StateStreamable<TState>> extends StatelessWidget {
  final String initialMessage;
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget Function(TResult item, int index) itemBuilder;
  final Function(TCubit cubit, String query) onRetry;
  final Function(TCubit cubit, int page) onPageChanged;
  final ScrollController? scrollController; 

  const BaseSearchResultsView({
    super.key,
    required this.initialMessage,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.itemBuilder,
    required this.onRetry,
    required this.onPageChanged,
    this.scrollController, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCubit, TState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            // Sayfa navigasyonu
            if (state.status == SearchStatus.success)
              GenericPaginationControls(
                currentPage: state.currentPage,
                hasReachedMax: state.hasReachedMax,
                onPageChanged: (page) => onPageChanged(context.read<TCubit>(), page),
                maxPages: 10,
              ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, TState state) {
    switch (state.status) {
      case SearchStatus.initial:
        return SearchInitialWidget(message: initialMessage);
      case SearchStatus.loading:
        return const AppLoadingIndicator();
      case SearchStatus.empty:
        return AppEmptyState(message: emptyMessage, icon: emptyIcon);
      case SearchStatus.failure:
        return GenericSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => onRetry(context.read<TCubit>(), state.query),
        );
      case SearchStatus.success:
        return state.results.isEmpty
            ? AppEmptyState(message: emptyMessage, icon: emptyIcon)
            : GenericSearchResultsList<TResult>(
                results: state.results,
                itemBuilder: itemBuilder,
                scrollController: scrollController, 
              );
    }
  }
}


