import 'package:hive/hive.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/domain/entities/news_search_result.dart';

part 'tab_data.g.dart';

@HiveType(typeId: 2)
class TabData {
  @HiveField(0)
  final String tabId;
  
  @HiveField(1)
  final String query;
  
  @HiveField(2)
  final List<WebSearchResult> webResults;
  
  @HiveField(3)
  final List<NewsSearchResult> newsResults;
  
  @HiveField(4)
  final DateTime lastUpdated;
  
  @HiveField(5)
  final String searchType; 
  
  TabData({
    required this.tabId,
    required this.query,
    required this.webResults,
    required this.newsResults,
    required this.lastUpdated,
    required this.searchType,
  });
}