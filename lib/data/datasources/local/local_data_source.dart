import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';


abstract class LocalDataSource {
  Future<void> init();
  Future<void> saveSearchHistory(SearchHistoryItem item);
  Future<List<SearchHistoryItem>> getSearchHistory();
  Future<void> clearSearchHistory();
  Future<void> saveTabData(TabData tabData);
  Future<Map<String, TabData>> getTabData();
  Future<void> deleteTabData(String tabId);
  Future<void> clearAllTabData();
}


@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  static const String _searchHistoryBox = 'searchHistory';
  static const String _tabDataBox = 'tabData';

  @override
  Future<void> init() async {
    await Hive.openBox<SearchHistoryItem>(_searchHistoryBox);
    await Hive.openBox<TabData>(_tabDataBox);
  }

  @override
  Future<void> saveSearchHistory(SearchHistoryItem item) async {
    final box = Hive.box<SearchHistoryItem>(_searchHistoryBox);
    await box.add(item);
  }

  @override
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    final box = Hive.box<SearchHistoryItem>(_searchHistoryBox);
    return box.values.toList();
  }

  @override
  Future<void> clearSearchHistory() async {
    final box = Hive.box<SearchHistoryItem>(_searchHistoryBox);
    await box.clear();
  }

  @override
  Future<void> saveTabData(TabData tabData) async {
    final box = Hive.box<TabData>(_tabDataBox);
    await box.put(tabData.tabId, tabData);
  }

  @override
  Future<Map<String, TabData>> getTabData() async {
    final box = Hive.box<TabData>(_tabDataBox);
    return Map.fromEntries(box.values.map((tab) => MapEntry(tab.tabId, tab)));
  }

  @override
  Future<void> deleteTabData(String tabId) async {
    final box = Hive.box<TabData>(_tabDataBox);
    await box.delete(tabId);
  }

  @override
  Future<void> clearAllTabData() async {
    final box = Hive.box<TabData>(_tabDataBox);
    await box.clear();
  }
}