import 'package:equatable/equatable.dart';

import '../../../domain/entities/web_search_result.dart';

enum WebSearchStatus { 
  initial, 
  loading, 
  success, 
  failure,
  empty 
}

class WebSearchState extends Equatable {
  final WebSearchStatus status;
  final List<WebSearchResult> results;
  final String query;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;

  const WebSearchState({
    this.status = WebSearchStatus.initial,
    this.results = const <WebSearchResult>[],
    this.query = '',
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  WebSearchState copyWith({
    WebSearchStatus? status,
    List<WebSearchResult>? results,
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