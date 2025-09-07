import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';

@injectable
class ClearSearchHistory {
  final LocalRepository _localRepository;

  ClearSearchHistory(this._localRepository);

  Future<void> call() {
    return _localRepository.clearSearchHistory();
  }
}