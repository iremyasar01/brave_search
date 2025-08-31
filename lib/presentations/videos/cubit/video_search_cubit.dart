import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/video_search_use_case.dart';
import 'video_search_state.dart';

@injectable
class VideoSearchCubit extends Cubit<VideoSearchState> {
  final VideoSearchUseCase videoSearchUseCase;

  VideoSearchCubit(this.videoSearchUseCase) : super(const VideoSearchState());

  Future<void> searchVideos(
    String query, {
    String? country,
    String safesearch = 'strict',
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: VideoSearchStatus.empty));
      return;
    }

    emit(state.copyWith(
      status: VideoSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
    ));

    try {
      final results = await videoSearchUseCase.execute(
        query,
        country: country,
        safesearch: safesearch,
      );
      
      if (results.isEmpty) {
        emit(state.copyWith(
          status: VideoSearchStatus.empty,
          results: [],
        ));
      } else {
        emit(state.copyWith(
          status: VideoSearchStatus.success,
          results: results,
          hasReachedMax: results.length < 20,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: VideoSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore({
    String? country,
    String safesearch = 'strict',
  }) async {
    if (state.hasReachedMax || state.status == VideoSearchStatus.loading) return;

    try {
      final results = await videoSearchUseCase.execute(
        state.query,
        page: state.currentPage + 1,
        country: country,
        safesearch: safesearch,
      );

      final hasReachedMax = results.length < 20;
      
      emit(state.copyWith(
        status: VideoSearchStatus.success,
        results: List.of(state.results)..addAll(results),
        currentPage: state.currentPage + 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VideoSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearResults() {
    emit(const VideoSearchState());
  }
}