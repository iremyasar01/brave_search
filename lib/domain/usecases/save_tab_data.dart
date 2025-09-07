import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';
import 'package:brave_search/domain/entities/tab_data.dart';

@injectable
class SaveTabData {
  final LocalRepository _localRepository;

  SaveTabData(this._localRepository);

  Future<void> call(TabData tabData) {
    return _localRepository.saveTabData(tabData);
  }
}