import 'package:equatable/equatable.dart';

import '../../../domain/entities/video_search_result.dart';

enum VideoSearchStatus { 
  initial, 
  loading, 
  success, 
  failure,
  empty 
}

class VideoSearchState extends Equatable {
  final VideoSearchStatus status;
  final List<VideoSearchResult> results;
  final String query;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;

  const VideoSearchState({
    this.status = VideoSearchStatus.initial,
    this.results = const <VideoSearchResult>[],
    this.query = '',
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  VideoSearchState copyWith({
    VideoSearchStatus? status,
    List<VideoSearchResult>? results,
    String? query,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return VideoSearchState(
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