import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


import '../../../domain/usecases/search_use_case.dart';
import 'web_search_state.dart';

@injectable
class WebSearchCubit extends Cubit<WebSearchState> {
  final SearchUseCase searchUseCase;

  WebSearchCubit(this.searchUseCase) : super(const WebSearchState());

  Future<void> search(String query, {String searchType = 'web'}) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: SearchStatus.empty));
      return;
    }

    emit(state.copyWith(
      status: SearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
    ));

    try {
      final results = await searchUseCase.execute(query, searchType: searchType);
      
      if (results.isEmpty) {
        emit(state.copyWith(
          status: SearchStatus.empty,
          results: [],
        ));
      } else {
        emit(state.copyWith(
          status: SearchStatus.success,
          results: results,
          hasReachedMax: results.length < 20,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore({String searchType = 'web'}) async {
    if (state.hasReachedMax || state.status == SearchStatus.loading) return;

    try {
      final results = await searchUseCase.execute(
        state.query,
        searchType: searchType,
        page: state.currentPage + 1,
      );

      final hasReachedMax = results.length < 20;
      
      emit(state.copyWith(
        status: SearchStatus.success,
        results: List.of(state.results)..addAll(results),
        currentPage: state.currentPage + 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearResults() {
    emit(const WebSearchState());
  }
}