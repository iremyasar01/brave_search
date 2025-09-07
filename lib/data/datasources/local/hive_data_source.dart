import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/domain/entities/tab_data.dart';
import 'package:hive/hive.dart';

// Yerel veri kaynağı arayüzü
abstract class LocalDataSource {
  Future<void> init(); // Hive bağlantılarını başlat
  Future<void> saveSearchHistory(SearchHistoryItem item); // Arama geçmişini kaydet
  Future<List<SearchHistoryItem>> getSearchHistory(); // Arama geçmişini getir
  Future<void> clearSearchHistory(); // Arama geçmişini temizle
  Future<void> saveTabData(TabData tabData); // Sekme verilerini kaydet
  Future<Map<String, TabData>> getTabData(); // Tüm sekme verilerini getir
  Future<void> deleteTabData(String tabId); // Belirli bir sekmeyi sil
  Future<void> clearAllTabData(); // Tüm sekme verilerini temizle
}

// Hive veritabanı işlemlerini yöneten sınıf
class HiveDataSource implements LocalDataSource {
  static const String _searchHistoryBox = 'searchHistory'; // Arama geçmişi kutusu
  static const String _tabDataBox = 'tabData'; // Sekme verileri kutusu

  @override
  Future<void> init() async {
    // Hive bağlantılarını başlat - adaptörler main'de kayıtlı olmalı
    await Hive.openBox<SearchHistoryItem>(_searchHistoryBox);
    await Hive.openBox<TabData>(_tabDataBox);
  }

  @override
  Future<void> saveSearchHistory(SearchHistoryItem item) async {
    final box = Hive.box<SearchHistoryItem>(_searchHistoryBox);
    await box.add(item); // Yeni arama geçmişi öğesi ekle
  }

  @override
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    final box = Hive.box<SearchHistoryItem>(_searchHistoryBox);
    return box.values.toList(); // Tüm arama geçmişini listeye dönüştür ve döndür
  }

  @override
  Future<void> clearSearchHistory() async {
    final box = Hive.box<SearchHistoryItem>(_searchHistoryBox);
    await box.clear(); // Tüm arama geçmişini temizle
  }

  @override
  Future<void> saveTabData(TabData tabData) async {
    final box = Hive.box<TabData>(_tabDataBox);
    await box.put(tabData.tabId, tabData); // Sekme verisini ID ile kaydet
  }

  @override
  Future<Map<String, TabData>> getTabData() async {
    final box = Hive.box<TabData>(_tabDataBox);
    // Tüm sekmeleri Map yapısına dönüştür (tabId -> TabData)
    return Map.fromEntries(box.values.map((tab) => MapEntry(tab.tabId, tab)));
  }

  @override
  Future<void> deleteTabData(String tabId) async {
    final box = Hive.box<TabData>(_tabDataBox);
    await box.delete(tabId); // Belirli bir sekmeyi ID ile sil
  }

  @override
  Future<void> clearAllTabData() async {
    final box = Hive.box<TabData>(_tabDataBox);
    await box.clear(); // Tüm sekme verilerini temizle
  }
}