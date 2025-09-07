import 'package:hive/hive.dart';

part 'search_history_item.g.dart';

@HiveType(typeId: 1)
class SearchHistoryItem {
  @HiveField(0)
  final String query;
  
  @HiveField(1)
  final DateTime timestamp;
  
  @HiveField(2)
  final String tabId;
  
  @HiveField(3)
  final String searchType; // 'web' veya 'news'
  
  SearchHistoryItem({
    required this.query,
    required this.timestamp,
    required this.tabId,
    required this.searchType,
  });
}