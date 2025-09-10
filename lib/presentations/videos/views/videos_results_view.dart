import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/initial/search_initial_state.dart';
import 'package:brave_search/common/widgets/search/pagination_controls.dart';
import 'package:brave_search/common/widgets/search/search_error_widget.dart';
import 'package:brave_search/common/widgets/search/search_results_list.dart';
import 'package:brave_search/core/widgets/empty/empty_state.dart';
import 'package:brave_search/core/widgets/loading/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/video_search_cubit.dart';
import '../cubit/video_search_state.dart';
import '../widgets/video_search_result_item.dart';

class VideosResultsView extends StatelessWidget {
  final ScrollController? scrollController;

  const VideosResultsView({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoSearchCubit, VideoSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: _buildContent(context, state),
            ),
            // Sayfa navigasyonu - sadece success durumunda göster
            if (state.status == VideoSearchStatus.success)
              GenericPaginationControls(
                currentPage: state.currentPage,
                hasReachedMax: state.hasReachedMax,
                onPageChanged: (page) => context.read<VideoSearchCubit>().loadPage(page),
                maxPages: 10, // Video arama için maksimum 10 sayfa
              ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, VideoSearchState state) {
    switch (state.status) {
      case VideoSearchStatus.initial:
        return const SearchInitialWidget(message: VideoSearchStrings.videoInitialMessage);
      case VideoSearchStatus.loading:
        return const AppLoadingIndicator();
      case VideoSearchStatus.empty:
        return const AppEmptyState(
          message: VideoSearchStrings.videoEmptyMessage, 
          icon: Icons.video_library_outlined,
        );
      case VideoSearchStatus.failure:
        return GenericSearchErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => context.read<VideoSearchCubit>().searchVideo(state.query),
        );
      case VideoSearchStatus.success:
        return state.results.isEmpty
            ? const AppEmptyState(
                message: VideoSearchStrings.videoNoResultsMessage, 
                icon: Icons.video_library_outlined,
              )
            : GenericSearchResultsList(
                results: state.results,
                itemBuilder: (result, index) => VideoSearchResultItem(result: result),
                scrollController: scrollController,
              );
    }
  }
}