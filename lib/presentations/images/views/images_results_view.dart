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

  const ImagesResultsView({super.key, this.scrollController});

  @override
   Widget build(BuildContext context) {
    return BlocBuilder<ImageSearchCubit, ImageSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            // Sayfa navigasyonu - en alta taşındı
            if (state.status == ImageSearchStatus.success)
              ImageSearchPaginationControls(state: state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ImageSearchState state) {
    switch (state.status) {
      case ImageSearchStatus.initial:
        return const SearchInitialWidget(message: ImageSearchStrings.imageInitialMessage,);
      case ImageSearchStatus.loading:
        return const AppLoadingIndicator();
      case ImageSearchStatus.empty:
        return const AppEmptyState( message: ImageSearchStrings.imageEmptyMessage,
      icon: Icons.image_not_supported);
      case ImageSearchStatus.failure:
        return ImageSearchErrorWidget(
          errorMessage: state.errorMessage,
          query: state.query,
        );
      case ImageSearchStatus.success:
        return ImageSearchResultsGrid(results: state.results );
    }
  }
}
