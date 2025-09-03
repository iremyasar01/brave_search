import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/news_search_use_case.dart';
import 'news_search_state.dart';

@injectable
class NewsSearchCubit extends Cubit<NewsSearchState> {
  final NewsSearchUseCase newsSearchUseCase;
  final Map<int, List<NewsSearchResult>> _pageCache = {};
  static const int maxPages = 10; // Maksimum 10 sayfa (offset 0-9)

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

    // Yeni arama yapılıyorsa cache'i temizle
    if (state.query != query) {
      _pageCache.clear();
    }

    emit(state.copyWith(
      status: NewsSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
      results: [],
    ));

    await _loadPage(1, country: country, safesearch: safesearch);
  }

  Future<void> loadPage(int page) async {
    // Sayfa sınırını kontrol et (1-10 arası)
    if (page < 1 || page > maxPages) {
      return;
    }
    
    if (state.status == NewsSearchStatus.loading) return;
    
    // Eğer bu sayfa önceden yüklenmişse, cache'ten göster
    if (_pageCache.containsKey(page)) {
      emit(state.copyWith(
        status: NewsSearchStatus.success,
        results: _pageCache[page]!,
        currentPage: page,
      ));
      return;
    }

    await _loadPage(page);
  }

  Future<void> _loadPage(int page, {String? country, String? safesearch}) async {
    emit(state.copyWith(status: NewsSearchStatus.loading));

    final result = await newsSearchUseCase.execute(
      state.query,
      page: page,
      country: country,
      safesearch: safesearch ?? 'strict',
    );

    result.map(
      success: (data) {
        // Sonuçları cache'e kaydet
        _pageCache[page] = data;
        
        // hasReachedMax kontrolü:
        // 1. Sayfa 10'a ulaştıysa (API sınırı)
        // 2. Veya sonuç boşsa
        // 3. Veya beklenen sonuç sayısından azsa
        final hasReachedMax = page >= maxPages ||
            data.isEmpty ||
            data.length < 20;

        emit(state.copyWith(
          status: NewsSearchStatus.success,
          results: data,
          currentPage: page,
          hasReachedMax: hasReachedMax,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: NewsSearchStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }

  void clearResults() {
    _pageCache.clear();
    emit(const NewsSearchState());
  }
}