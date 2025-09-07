import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/image_search_use_case.dart';
import 'image_search_state.dart';

@injectable
class ImageSearchCubit extends Cubit<ImageSearchState> {
  final ImageSearchUseCase imageSearchUseCase;
  final Map<String, List<ImageSearchResult>> _queryCache = {};
  final Map<String, Map<int, List<ImageSearchResult>>> _pageCache = {};

  ImageSearchCubit(this.imageSearchUseCase) : super(const ImageSearchState());

  Future<void> searchImages(
    String query, {
    String? country,
    String safesearch = 'strict',
    bool forceRefresh = false,
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: ImageSearchStatus.empty));
      return;
    }

    // Aynı sorgu için cache'de veri varsa ve forceRefresh false ise cache'den getir
    if (!forceRefresh && 
        _isCached(query) && 
        state.status != ImageSearchStatus.loading) {
      _emitFromCache(query, 1);
      return;
    }

    emit(state.copyWith(
      status: ImageSearchStatus.loading,
      query: query,
      currentPage: 1,
      hasReachedMax: false,
      results: [],
    ));

    final result = await imageSearchUseCase.execute(
      query,
      country: country,
      safesearch: safesearch,
    );

    result.map(
      success: (data) {
        // Tüm sonuçları cache'e kaydet
        _queryCache[query] = data;

        if (data.isEmpty) {
          emit(state.copyWith(
            status: ImageSearchStatus.empty,
            results: [],
            totalPages: 1,
          ));
        } else {
          const itemsPerPage = 10;
          final totalPages = (data.length / itemsPerPage).ceil();

          // İlk sayfayı göster (ilk 10 sonuç)
          final firstPageResults = _getPageResults(data, 1, itemsPerPage);
          
          // Sayfa cache'ini güncelle
          _updatePageCache(query, 1, firstPageResults);
          
          emit(state.copyWith(
            status: ImageSearchStatus.success,
            results: firstPageResults,
            currentPage: 1,
            hasReachedMax: firstPageResults.length < itemsPerPage,
            totalPages: totalPages,
          ));
        }
      },
      failure: (error) {
        emit(state.copyWith(
          status: ImageSearchStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }

  Future<void> loadPage(int page, {bool forceRefresh = false}) async {
    if (state.status == ImageSearchStatus.loading) return;

    // Aynı sorgu ve sayfa için cache'de veri varsa ve forceRefresh false ise cache'den getir
    if (!forceRefresh && 
        _isPageCached(state.query, page) && 
        state.status != ImageSearchStatus.loading) {
      _emitPageFromCache(state.query, page);
      return;
    }

    const itemsPerPage = 10;
    
    if (_queryCache.containsKey(state.query)) {
      // Yerelde sakladığımız tüm sonuçlardan ilgili sayfayı al
      final pageResults = _getPageResults(_queryCache[state.query]!, page, itemsPerPage);
      
      // Sayfa cache'ini güncelle
      _updatePageCache(state.query, page, pageResults);
      
      emit(state.copyWith(
        status: ImageSearchStatus.success,
        results: pageResults,
        currentPage: page,
        hasReachedMax: pageResults.length < itemsPerPage,
      ));
    }
  }

  // Sayfa numarasına göre sonuçları döndürür
  List<ImageSearchResult> _getPageResults(List<ImageSearchResult> allResults, int page, int itemsPerPage) {
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= allResults.length) {
      return [];
    }

    return allResults.sublist(
      startIndex,
      endIndex.clamp(0, allResults.length),
    );
  }

  bool _isCached(String query) {
    return _queryCache.containsKey(query);
  }

  bool _isPageCached(String query, int page) {
    return _pageCache.containsKey(query) && _pageCache[query]!.containsKey(page);
  }

  void _emitFromCache(String query, int page) {
    if (_isPageCached(query, page)) {
      _emitPageFromCache(query, page);
    } else if (_queryCache.containsKey(query)) {
      const itemsPerPage = 10;
      final pageResults = _getPageResults(_queryCache[query]!, page, itemsPerPage);
      
      // Sayfa cache'ini güncelle
      _updatePageCache(query, page, pageResults);
      
      emit(state.copyWith(
        status: ImageSearchStatus.success,
        results: pageResults,
        currentPage: page,
        query: query,
        hasReachedMax: pageResults.length < itemsPerPage,
      ));
    }
  }

  void _emitPageFromCache(String query, int page) {
    final cachedResults = _pageCache[query]![page]!;
    const itemsPerPage = 10;
    
    emit(state.copyWith(
      status: ImageSearchStatus.success,
      results: cachedResults,
      currentPage: page,
      query: query,
      hasReachedMax: cachedResults.length < itemsPerPage,
    ));
  }

  void _updatePageCache(String query, int page, List<ImageSearchResult> results) {
    if (!_pageCache.containsKey(query)) {
      _pageCache[query] = {};
    }
    _pageCache[query]![page] = results;
  }

  void clearResults() {
    _queryCache.clear();
    _pageCache.clear();
    emit(const ImageSearchState());
  }
}