import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/web_search_use_case.dart';
import 'web_search_state.dart';

@injectable
class WebSearchCubit extends Cubit<WebSearchState> {
  final WebSearchUseCase webSearchUseCase;
  final Map<int, List<WebSearchResult>> _pageCache = {};
  static const int maxPages = 10;

  WebSearchCubit(this.webSearchUseCase) : super(const WebSearchState());

  Future<void> searchWeb(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return;

    // Sayfa sınırını kontrol et
    if (page < 1 || page > maxPages) {
      debugPrint('Sayfa sınırı aşıldı: $page (Max: $maxPages)');
      return;
    }

    // Yeni arama yapılıyorsa cache'i temizle
    if (state.query != query) {
      _pageCache.clear();
    }

    // İlk sayfa için loading state
    if (page == 1) {
      emit(state.copyWith(
        status: WebSearchStatus.loading,
        query: query,
        currentPage: page,
        hasReachedMax: false,
        results: [],
      ));
    } else {
      // Diğer sayfalar için mevcut durumu koru ama loading göster
      emit(state.copyWith(
        status: WebSearchStatus.loading,
        currentPage: page,
      ));
    }

    // Eğer bu sayfa önceden yüklenmişse, cache'ten göster
    if (_pageCache.containsKey(page)) {
      emit(state.copyWith(
        status: WebSearchStatus.success,
        results: _pageCache[page]!,
        currentPage: page,
      ));
      return;
    }

    final result = await webSearchUseCase.execute(
      query,
      page: page,
      count: 20,
    );

    result.map(
      success: (results) {
        // Sonuçları cache'e kaydet
        _pageCache[page] = results;
        
        if (results.isEmpty && page == 1) {
          emit(state.copyWith(
            status: WebSearchStatus.empty,
            results: [],
            hasReachedMax: true,
            currentPage: page,
          ));
        } else {
          final hasReachedMax = page >= maxPages ||
              results.isEmpty ||
              results.length < 10;

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
      await searchWeb(state.query, page: page);
    }
  }

  void clearResults() {
    _pageCache.clear();
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