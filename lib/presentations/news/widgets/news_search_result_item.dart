import 'package:brave_search/common/widgets/search/base_search_result_item.dart';
import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:brave_search/presentations/news/widgets/news_content.dart';
import 'package:brave_search/presentations/news/widgets/news_thumbnail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class NewsSearchResultItem extends BaseSearchResultItem {
  final NewsSearchResult result;

  NewsSearchResultItem({super.key, required this.result})
      : super(url: result.url, title: result.title);
  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: NewsContent(
              title: result.title,
              description: result.description,
              hostname: result.metaUrl?.hostname,
              age: result.age,
            ).allPadding(12),
          ),
          if (result.thumbnail.src.isNotEmpty) ...[
            const SizedBox().spaceRight(12),
            NewsThumbnailWidgets(
              src: result.thumbnail.src,
              publisher: result.metaUrl?.hostname,
            ).onlyPadding(top: 12, right: 12, bottom: 12),
          ],
        ],
      ),
    );
  }
}
