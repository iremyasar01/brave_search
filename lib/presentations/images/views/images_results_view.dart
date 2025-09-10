import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/initial/search_initial_state.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:brave_search/presentations/images/widgets/image_search_error_widget.dart';
import 'package:brave_search/presentations/images/widgets/image_search_pagination_controls.dart';
import 'package:brave_search/presentations/images/widgets/image_search_results_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/image_search_cubit.dart';
import '../cubit/image_search_state.dart';

class ImagesResultsView extends StatelessWidget {
  final ScrollController? scrollController;
  final ValueNotifier<bool>? paginationVisibilityNotifier;
  final ValueNotifier<bool>? headerVisibilityNotifier;

  const ImagesResultsView({
    super.key, 
    this.scrollController, 
    this.paginationVisibilityNotifier,
    this.headerVisibilityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageSearchCubit, ImageSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            // Sayfa navigasyonu - scroll durumuna göre görünür/gizli
            if (state.status == ImageSearchStatus.success && state.totalPages > 1)
              ValueListenableBuilder<bool>(
                valueListenable: paginationVisibilityNotifier ?? ValueNotifier(true),
                builder: (context, isVisible, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: isVisible ? null : 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isVisible ? 1.0 : 0.0,
                      child: isVisible 
                        ? ImageSearchPaginationControls(state: state)
                        : const SizedBox.shrink(),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ImageSearchState state) {
    switch (state.status) {
      case ImageSearchStatus.initial:
        return const SearchInitialWidget(
          message: ImageSearchStrings.imageInitialMessage,
        );
      case ImageSearchStatus.loading:
        return const AppLoadingIndicator();
      case ImageSearchStatus.empty:
        return const AppEmptyState(
          message: ImageSearchStrings.imageEmptyMessage,
          icon: Icons.image_not_supported,
        );
      case ImageSearchStatus.failure:
        return ImageSearchErrorWidget(
          errorMessage: state.errorMessage,
          query: state.query,
        );
      case ImageSearchStatus.success:
        return ImageSearchResultsGrid(
          results: state.results,
          scrollController: scrollController,
        );
    }
  }
}