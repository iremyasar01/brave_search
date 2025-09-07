import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';
import 'package:brave_search/domain/entities/tab_data.dart';

@injectable
class GetTabData {
  final LocalRepository _localRepository;

  GetTabData(this._localRepository);

  Future<Map<String, TabData>> call() {
    return _localRepository.getTabData();
  }
}