import 'package:brave_search/common/interfaces/base_search_cubit.dart';
import 'package:brave_search/core/cache/cache_manager.dart';
import 'package:brave_search/domain/entities/video_search_result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/video_search_use_case.dart';
import 'video_search_state.dart';

@injectable
class VideoSearchCubit extends BaseSearchCubit<VideoSearchResult, VideoSearchState> {
  final VideoSearchUseCase videoSearchUseCase;
  final Map<String, int> _queryCurrentPage = {};
  static const int maxPages = 10;

  VideoSearchCubit(
    this.videoSearchUseCase,
    @Named('videoCacheManager') CacheManager<VideoSearchResult> cacheManager,
  ) : super(cacheManager, const VideoSearchState());

  Future<void> searchVideo(String query, {int? page, bool forceRefresh = false}) async {
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
        status: VideoSearchStatus.loading,
        query: query,
        currentPage: targetPage,
        hasReachedMax: false,
        results: [],
      ));
    } else {
      emit(state.copyWith(
        status: VideoSearchStatus.loading,
        currentPage: targetPage,
      ));
    }

    final result = await videoSearchUseCase.execute(
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
            status: VideoSearchStatus.empty,
            results: [],
            hasReachedMax: true,
            currentPage: targetPage,
          ));
        } else {
          final hasReachedMax = targetPage >= maxPages ||
              results.isEmpty ||
              results.length < 10;

          emit(state.copyWith(
            status: VideoSearchStatus.success,
            results: results,
            currentPage: targetPage,
            hasReachedMax: hasReachedMax,
            query: query,
          ));
        }
      },
      failure: (error) {
        emit(state.copyWith(
          status: VideoSearchStatus.failure,
          errorMessage: error,
          currentPage: targetPage,
        ));
      },
    );
  }

  @override
  void _emitCachedResults(String query, int page, List<VideoSearchResult> results) {
    emit(state.copyWith(
      status: VideoSearchStatus.success,
      results: results,
      currentPage: page,
      query: query,
      hasReachedMax: page >= maxPages || results.isEmpty || results.length < 10,
    ));
  }

  Future<void> loadPage(int page) async {
    if (state.query.isNotEmpty && page >= 1 && page <= maxPages) {
      await searchVideo(state.query, page: page);
    }
  }

  void clearResults() {
    clearCache();
    _queryCurrentPage.clear();
    emit(const VideoSearchState());
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