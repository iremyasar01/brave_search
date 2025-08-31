import 'package:equatable/equatable.dart';
import '../../../domain/entities/news_search_result.dart';

enum NewsSearchStatus { 
  initial, 
  loading, 
  success, 
  failure,
  empty 
}

class NewsSearchState extends Equatable {
  final NewsSearchStatus status;
  final List<NewsSearchResult> results;
  final String query;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;

  const NewsSearchState({
    this.status = NewsSearchStatus.initial,
    this.results = const <NewsSearchResult>[],
    this.query = '',
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  NewsSearchState copyWith({
    NewsSearchStatus? status,
    List<NewsSearchResult>? results,
    String? query,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return NewsSearchState(
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