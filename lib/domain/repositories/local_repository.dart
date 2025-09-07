import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';

abstract class LocalRepository {
  Future<void> init();
  Future<void> saveSearchHistory(SearchHistoryItem item);
  Future<List<SearchHistoryItem>> getSearchHistory();
  Future<void> clearSearchHistory();
  Future<void> saveTabData(TabData tabData);
  Future<Map<String, TabData>> getTabData();
  Future<void> deleteTabData(String tabId);
  Future<void> clearAllTabData();
}