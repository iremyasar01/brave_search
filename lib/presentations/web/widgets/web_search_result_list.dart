import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/presentations/web/widgets/web_search_result_item.dart';
import 'package:flutter/material.dart';
class WebSearchResultsList extends StatelessWidget {
  final List<WebSearchResult> results;

  const WebSearchResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: WebSearchResultItem(result: results[index]),
        );
      },
    );
  }
}