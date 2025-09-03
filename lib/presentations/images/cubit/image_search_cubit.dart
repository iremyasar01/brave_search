import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/image_search_use_case.dart';
import 'image_search_state.dart';

@injectable
class ImageSearchCubit extends Cubit<ImageSearchState> {
  final ImageSearchUseCase imageSearchUseCase;
  List<ImageSearchResult> _allResults = []; // Tüm sonuçları saklayacağız

  ImageSearchCubit(this.imageSearchUseCase) : super(const ImageSearchState());

  Future<void> searchImages(
    String query, {
    String? country,
    String safesearch = 'strict',
  }) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(status: ImageSearchStatus.empty));
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
        _allResults = data; // Tüm sonuçları sakla

        if (data.isEmpty) {
          emit(state.copyWith(
            status: ImageSearchStatus.empty,
            results: [],
            totalPages: 1,
          ));
        } else {
          const itemsPerPage = 10;
          final totalPages = (data.length / itemsPerPage).ceil(); // Toplam sayfa sayısı

          // İlk sayfayı göster (ilk 10 sonuç)
          final firstPageResults = _getPageResults(1, itemsPerPage);
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

  Future<void> loadPage(int page) async {
    if (state.status == ImageSearchStatus.loading) return;

    const itemsPerPage = 10;
    
    // Yerelde sakladığımız tüm sonuçlardan ilgili sayfayı al
    final pageResults = _getPageResults(page, itemsPerPage);

    emit(state.copyWith(
      status: ImageSearchStatus.success,
      results: pageResults,
      currentPage: page,
      hasReachedMax: pageResults.length < itemsPerPage,
      // totalPages değişmediği için aynı kalacak
    ));
  }

  // Sayfa numarasına göre sonuçları döndürür
  List<ImageSearchResult> _getPageResults(int page, int itemsPerPage) {
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= _allResults.length) {
      return [];
    }

    return _allResults.sublist(
      startIndex,
      endIndex.clamp(0, _allResults.length),
    );
  }

  void clearResults() {
    _allResults = [];
    emit(const ImageSearchState());
  }
}