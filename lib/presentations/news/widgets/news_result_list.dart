import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:flutter/material.dart';
import 'news_search_result_item.dart';

class NewsSearchResultsList extends StatelessWidget {
  final List<NewsSearchResult> results;

  const NewsSearchResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return NewsSearchResultItem(result: results[index]);
      },
    );
  }
}