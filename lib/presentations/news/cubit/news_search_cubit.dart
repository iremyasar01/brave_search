import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/news_search_use_case.dart';
import 'news_search_state.dart';

@injectable
class NewsSearchCubit extends Cubit<NewsSearchState> {
  final NewsSearchUseCase newsSearchUseCase;

  NewsSearchCubit(this.newsSearchUseCase) : super(const NewsSearchState());

  Future<void> searchNews(
    String query, {
    String? country,
    String safesearch = 'strict',
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: NewsSearchStatus.empty));
      return;
    }

    emit(state.copyWith(
      status: NewsSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
    ));

    try {
      final results = await newsSearchUseCase.execute(
        query,
        country: country,
        safesearch: safesearch,
      );
      
      if (results.isEmpty) {
        emit(state.copyWith(
          status: NewsSearchStatus.empty,
          results: [],
        ));
      } else {
        emit(state.copyWith(
          status: NewsSearchStatus.success,
          results: results,
          hasReachedMax: results.length < 20,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: NewsSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore({
    String? country,
    String safesearch = 'strict',
  }) async {
    if (state.hasReachedMax || state.status == NewsSearchStatus.loading) return;

    try {
      final results = await newsSearchUseCase.execute(
        state.query,
        page: state.currentPage + 1,
        country: country,
        safesearch: safesearch,
      );

      final hasReachedMax = results.length < 20;
      
      emit(state.copyWith(
        status: NewsSearchStatus.success,
        results: List.of(state.results)..addAll(results),
        currentPage: state.currentPage + 1,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NewsSearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearResults() {
    emit(const NewsSearchState());
  }
}