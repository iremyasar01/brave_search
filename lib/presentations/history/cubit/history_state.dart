import 'package:brave_search/domain/entities/search_history_item.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<SearchHistoryItem> history;
  const HistoryLoaded(this.history);
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
}