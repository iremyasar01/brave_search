import 'package:brave_search/domain/entities/video_search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/video_search_use_case.dart';
import 'video_search_state.dart';

@injectable
class VideoSearchCubit extends Cubit<VideoSearchState> {
  final VideoSearchUseCase videoSearchUseCase;
  final Map<String, Map<int, List<VideoSearchResult>>> _queryCache = {};
  static const int maxPages = 10;

  VideoSearchCubit(this.videoSearchUseCase) : super(const VideoSearchState());

  Future<void> searchVideos(
    String query, {
    String? country,
    String safesearch = 'strict',
    bool forceRefresh = false,
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: VideoSearchStatus.empty));
      return;
    }

    // Aynı sorgu için cache'de veri varsa ve forceRefresh false ise cache'den getir
    if (!forceRefresh && 
        _isCached(query, 1) && 
        state.status != VideoSearchStatus.loading) {
      _emitFromCache(query, 1);
      return;
    }

    // Yeni arama yapılıyorsa cache'i temizle
    if (state.query != query) {
      _queryCache.remove(query);
    }

    emit(state.copyWith(
      status: VideoSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
      results: [],
    ));

    await _loadPage(1, country: country, safesearch: safesearch);
  }

  Future<void> loadPage(int page, {bool forceRefresh = false}) async {
    if (state.query.isEmpty) return;
    
    // Sayfa sınırını kontrol et (1-10 arası)
    if (page < 1 || page > maxPages) {
      return;
    }
    
    // Aynı sorgu ve sayfa için cache'de veri varsa ve forceRefresh false ise cache'den getir
    if (!forceRefresh && 
        _isCached(state.query, page) && 
        state.status != VideoSearchStatus.loading) {
      _emitFromCache(state.query, page);
      return;
    }
    
    if (state.status == VideoSearchStatus.loading) return;

    await _loadPage(page);
  }

  Future<void> _loadPage(int page, {String? country, String? safesearch}) async {
    emit(state.copyWith(status: VideoSearchStatus.loading));

    final result = await videoSearchUseCase.execute(
      state.query,
      page: page,
      country: country,
      safesearch: safesearch ?? 'strict',
    );

    result.map(
      success: (data) {
        // Sonuçları cache'e kaydet
        _addToCache(state.query, page, data);
        
        final hasReachedMax = page >= maxPages ||
            data.isEmpty ||
            data.length < 20;

        emit(state.copyWith(
          status: VideoSearchStatus.success,
          results: data,
          currentPage: page,
          hasReachedMax: hasReachedMax,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: VideoSearchStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }

  bool _isCached(String query, int page) {
    return _queryCache.containsKey(query) && _queryCache[query]!.containsKey(page);
  }

  void _emitFromCache(String query, int page) {
    final cachedResults = _queryCache[query]![page]!;
    emit(state.copyWith(
      status: VideoSearchStatus.success,
      results: cachedResults,
      currentPage: page,
      query: query,
      hasReachedMax: page >= maxPages || cachedResults.isEmpty || cachedResults.length < 20,
    ));
  }

  void _addToCache(String query, int page, List<VideoSearchResult> results) {
    if (!_queryCache.containsKey(query)) {
      _queryCache[query] = {};
    }
    _queryCache[query]![page] = results;
  }

  void clearResults() {
    _queryCache.clear();
    emit(const VideoSearchState());
  }
}