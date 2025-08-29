import 'package:equatable/equatable.dart';

import '../../../domain/entities/search_result.dart';

enum SearchStatus { 
  initial, 
  loading, 
  success, 
  failure,
  empty 
}

class WebSearchState extends Equatable {
  final SearchStatus status;
  final List<SearchResult> results;
  final String query;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;

  const WebSearchState({
    this.status = SearchStatus.initial,
    this.results = const <SearchResult>[],
    this.query = '',
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  WebSearchState copyWith({
    SearchStatus? status,
    List<SearchResult>? results,
    String? query,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return WebSearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
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
      ];
}