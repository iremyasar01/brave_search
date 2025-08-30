import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/web_search_use_case.dart';
import 'web_search_state.dart';

@injectable
class WebSearchCubit extends Cubit<WebSearchState> {
  final WebSearchUseCase webSearchUseCase;

  WebSearchCubit(this.webSearchUseCase) : super(const WebSearchState());

  Future<void> searchWeb(
    String query, {
    String? country,
    String safesearch = 'strict',
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: WebSearchStatus.empty));
      return;
    }

    emit(state.copyWith(
      status: WebSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
    ));

    try {
      final results = await webSearchUseCase.execute(
        query,
        country: country,
        safesearch: safesearch,
      );
      
      if (results.isEmpty) {
        emit(state.copyWith(
          status: WebSearchStatus.empty,
          results: [],
        ));
      } else {
        emit(state.copyWith(
          status: WebSearchStatus.success,
          results: results,
          hasReachedMax: results.length < 20,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: WebSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore({
    String? country,
    String safesearch = 'strict',
  }) async {
    if (state.hasReachedMax || state.status == WebSearchStatus.loading) return;

    try {
      final results = await webSearchUseCase.execute(
        state.query,
        page: state.currentPage + 1,
        country: country,
        safesearch: safesearch,
      );

      final hasReachedMax = results.length < 20;
      
      emit(state.copyWith(
        status: WebSearchStatus.success,
        results: List.of(state.results)..addAll(results),
        currentPage: state.currentPage + 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WebSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearResults() {
    emit(const WebSearchState());
  }
}