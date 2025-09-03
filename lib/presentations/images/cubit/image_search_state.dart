import 'package:equatable/equatable.dart';

import '../../../domain/entities/image_search_result.dart';

enum ImageSearchStatus { 
  initial, 
  loading, 
  success, 
  failure,
  empty 
}

class ImageSearchState extends Equatable {
  final ImageSearchStatus status;
  final List<ImageSearchResult> results;
  final String query;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages; // Toplam sayfa sayısı

  const ImageSearchState({
    this.status = ImageSearchStatus.initial,
    this.results = const <ImageSearchResult>[],
    this.query = '',
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  ImageSearchState copyWith({
    ImageSearchStatus? status,
    List<ImageSearchResult>? results,
    String? query,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
  }) {
    return ImageSearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [
        status,
        results,
        query,
        errorMessage,
        hasReachedMax,
        currentPage,
        totalPages,
      ];
}