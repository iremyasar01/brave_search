import 'package:brave_search/data/datasources/local/local_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:brave_search/domain/repositories/local_repository.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';

@LazySingleton(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final LocalDataSource _localDataSource;

  LocalRepositoryImpl(this._localDataSource);

  @override
  Future<void> init() => _localDataSource.init();

  @override
  Future<void> saveSearchHistory(SearchHistoryItem item) =>
      _localDataSource.saveSearchHistory(item);

  @override
  Future<List<SearchHistoryItem>> getSearchHistory() =>
      _localDataSource.getSearchHistory();

  @override
  Future<void> clearSearchHistory() => _localDataSource.clearSearchHistory();

  @override
  Future<void> saveTabData(TabData tabData) =>
      _localDataSource.saveTabData(tabData);

  @override
  Future<Map<String, TabData>> getTabData() => _localDataSource.getTabData();

  @override
  Future<void> deleteTabData(String tabId) => _localDataSource.deleteTabData(tabId);

  @override
  Future<void> clearAllTabData() => _localDataSource.clearAllTabData();
}