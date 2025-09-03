abstract class BaseSearchState<T> {
  SearchStatus get status;
  List<T> get results;
  String get query;
  String? get errorMessage;
  int get currentPage;
  bool get hasReachedMax;
}

enum SearchStatus {
  initial,
  loading,
  success,
  failure,
  empty,
}