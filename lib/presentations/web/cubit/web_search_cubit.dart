import 'package:brave_search/domain/usecases/web_search_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'web_search_state.dart';

class WebSearchCubit extends Cubit<WebSearchState> {
  final WebSearchUseCase webSearchUseCase;
  static const int maxPages = 10; // API offset 0-9 sınırı nedeniyle maksimum 10 sayfa

  WebSearchCubit(this.webSearchUseCase) : super(const WebSearchState());

  Future<void> searchWeb(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return;

    // Sayfa sınırını kontrol et
    if (page < 1 || page > maxPages) {
      print('Sayfa sınırı aşıldı: $page (Max: $maxPages)');
      return;
    }

    // İlk sayfa için loading state
    if (page == 1) {
      emit(state.copyWith(
        status: WebSearchStatus.loading,
        query: query,
        currentPage: page,
        hasReachedMax: false, // Reset et
      ));
    } else {
      // Diğer sayfalar için mevcut durumu koru ama loading göster
      emit(state.copyWith(
        status: WebSearchStatus.loading,
        currentPage: page,
      ));
    }

    final result = await webSearchUseCase.execute(
      query,
      page: page,
      count: 20, // API'den 20 sonuç iste
    );

    result.map(
      success: (results) {
        print('API Response: ${results.length} results for page $page');
        
        if (results.isEmpty && page == 1) {
          emit(state.copyWith(
            status: WebSearchStatus.empty,
            results: [],
            hasReachedMax: true,
            currentPage: page,
          ));
        } else {
          // hasReachedMax kontrolü:
          // 1. Sayfa 10'a ulaştıysa (API sınırı)
          // 2. Veya sonuç boşsa
          // 3. Veya beklenen sonuç sayısından çok azsa
          final hasReachedMax = page >= maxPages || 
                                results.isEmpty || 
                                results.length < 10; // Eğer 10'dan az sonuç varsa büyük ihtimalle son sayfa
          
          print('Page: $page, Results: ${results.length}, HasReachedMax: $hasReachedMax');
          
          emit(state.copyWith(
            status: WebSearchStatus.success,
            results: results,
            currentPage: page,
            hasReachedMax: hasReachedMax,
            query: query,
          ));
        }
      },
      failure: (error) {
        print('Search error: $error');
        emit(state.copyWith(
          status: WebSearchStatus.failure,
          errorMessage: error,
          currentPage: page,
        ));
      },
    );
  }

  Future<void> loadPage(int page) async {
    if (state.query.isNotEmpty && page >= 1 && page <= maxPages) {
      print('Loading page: $page');
      await searchWeb(state.query, page: page);
    } else {
      print('Invalid page request: $page (Query: "${state.query}")');
    }
  }

  void clearResults() {
    emit(const WebSearchState());
  }

  // Önceki sayfa
  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await loadPage(state.currentPage - 1);
    }
  }

  // Sonraki sayfa
  Future<void> nextPage() async {
    if (state.currentPage < maxPages && !state.hasReachedMax) {
      await loadPage(state.currentPage + 1);
    }
  }
}