import 'package:brave_search/common/interfaces/base_search_cubit.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:brave_search/core/cache/cache_manager.dart';
import 'package:brave_search/domain/usecases/web_search_use_case.dart';
import 'web_search_state.dart';

@injectable
class WebSearchCubit extends BaseSearchCubit<WebSearchResult, WebSearchState> {
  final WebSearchUseCase webSearchUseCase;
  final Map<String, int> _queryCurrentPage = {};
  static const int maxPages = 10;

  WebSearchCubit(
    this.webSearchUseCase,
    @Named('webCacheManager') CacheManager<WebSearchResult> cacheManager,
  ) : super(cacheManager, const WebSearchState());

  Future<void> searchWeb(String query, {int? page, bool forceRefresh = false}) async {
    if (query.trim().isEmpty) return;

    // Sayfa belirtilmemişse, önceki sayfayı kullan veya 1 yap
    final int targetPage = page ?? _queryCurrentPage[query] ?? 1;

    // Sayfa sınırını kontrol et
    if (targetPage < 1 || targetPage > maxPages) {
      debugPrint('Sayfa sınırı aşıldı: $targetPage (Max: $maxPages)');
      return;
    }

    // Cache kontrolü - forceRefresh false ise cache'den getir
    if (!forceRefresh && await checkAndEmitFromCache(query, targetPage)) {
      return;
    }

    // Yeni arama yapılıyorsa veya forceRefresh true ise loading state'i göster
    if (targetPage == 1 || state.query != query) {
      emit(state.copyWith(
        status: WebSearchStatus.loading,
        query: query,
        currentPage: targetPage,
        hasReachedMax: false,
        results: [],
      ));
    } else {
      emit(state.copyWith(
        status: WebSearchStatus.loading,
        currentPage: targetPage,
      ));
    }

    final result = await webSearchUseCase.execute(
      query,
      page: targetPage,
      count: 20,
    );

    result.map(
      success: (results) {
        // Sonuçları cache'e kaydet
        addToCache(query, targetPage, results);
        // Mevcut sayfayı sakla
        _queryCurrentPage[query] = targetPage;
        
        if (results.isEmpty && targetPage == 1) {
          emit(state.copyWith(
            status: WebSearchStatus.empty,
            results: [],
            hasReachedMax: true,
            currentPage: targetPage,
          ));
        } else {
          final hasReachedMax = targetPage >= maxPages ||
              results.isEmpty ||
              results.length < 10;

          emit(state.copyWith(
            status: WebSearchStatus.success,
            results: results,
            currentPage: targetPage,
            hasReachedMax: hasReachedMax,
            query: query,
          ));
        }
      },
      failure: (error) {
        emit(state.copyWith(
          status: WebSearchStatus.failure,
          errorMessage: error,
          currentPage: targetPage,
        ));
      },
    );
  }

  @override
  void emitCachedResults(String query, int page, List<WebSearchResult> results) {
    emit(state.copyWith(
      status: WebSearchStatus.success,
      results: results,
      currentPage: page,
      query: query,
      hasReachedMax: page >= maxPages || results.isEmpty || results.length < 10,
    ));
  }

  Future<void> loadPage(int page) async {
    if (state.query.isNotEmpty && page >= 1 && page <= maxPages) {
      await searchWeb(state.query, page: page);
    }
  }

  void clearResults() {
    clearCache();
    _queryCurrentPage.clear();
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