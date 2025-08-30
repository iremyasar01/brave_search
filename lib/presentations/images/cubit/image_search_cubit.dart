import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/image_search_use_case.dart';
import 'image_search_state.dart';

@injectable
class ImageSearchCubit extends Cubit<ImageSearchState> {
  final ImageSearchUseCase imageSearchUseCase;

  ImageSearchCubit(this.imageSearchUseCase) : super(const ImageSearchState());

  Future<void> searchImages(
    String query, {
    String? country,
    String safesearch = 'strict',
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: ImageSearchStatus.empty));
      return;
    }

    emit(state.copyWith(
      status: ImageSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
    ));

    try {
      final results = await imageSearchUseCase.execute(
        query,
        country: country,
        safesearch: safesearch,
      );
      
      if (results.isEmpty) {
        emit(state.copyWith(
          status: ImageSearchStatus.empty,
          results: [],
        ));
      } else {
        emit(state.copyWith(
          status: ImageSearchStatus.success,
          results: results,
          hasReachedMax: results.length < 20,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ImageSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore({
    String? country,
    String safesearch = 'strict',
  }) async {
    if (state.hasReachedMax || state.status == ImageSearchStatus.loading) return;

    try {
      final results = await imageSearchUseCase.execute(
        state.query,
        page: state.currentPage + 1,
        country: country,
        safesearch: safesearch,
      );

      final hasReachedMax = results.length < 20;
      
      emit(state.copyWith(
        status: ImageSearchStatus.success,
        results: List.of(state.results)..addAll(results),
        currentPage: state.currentPage + 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ImageSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearResults() {
    emit(const ImageSearchState());
  }
}