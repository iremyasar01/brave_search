import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';

@injectable
class DeleteTabData {
  final LocalRepository _localRepository;

  DeleteTabData(this._localRepository);

  Future<void> call(String tabId) {
    return _localRepository.deleteTabData(tabId);
  }
}