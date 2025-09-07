import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';

@injectable
class SaveSearchHistory {
  final LocalRepository _localRepository;

  SaveSearchHistory(this._localRepository);

  Future<void> call(SearchHistoryItem item) {
    return _localRepository.saveSearchHistory(item);
  }
}