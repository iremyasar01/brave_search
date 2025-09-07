import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';

@injectable
class GetSearchHistory {
  final LocalRepository _localRepository;

  GetSearchHistory(this._localRepository);

  Future<List<SearchHistoryItem>> call() {
    return _localRepository.getSearchHistory();
  }
}