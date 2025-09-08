import 'package:brave_search/common/widgets/search/base_search_result_item.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/presentations/web/widgets/web_search_cluster.dart';
import 'package:brave_search/presentations/web/widgets/web_search_indicator.dart';
import 'package:brave_search/presentations/web/widgets/web_search_top_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class WebSearchResultItem extends BaseSearchResultItem {
  final WebSearchResult result;

  WebSearchResultItem({super.key, required this.result})
      : super(url: result.url, title: result.title);

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WebSearchTopRow(result: result).allPadding(12),
          Text(
            result.title,
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ).symmetricPadding(horizontal: 12),
          Text(
            result.description,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ).allPadding(12),
          if (result.language != null || !result.familyFriendly)
            WebSearchIndicators(result: result)
                .onlyPadding(left: 12, right: 12, bottom: 8),
          if (result.cluster != null && result.cluster!.isNotEmpty)
            WebSearchCluster(cluster: result.cluster!)
                .symmetricPadding(horizontal: 12, vertical: 8),
        ],
      ),
    );
  }
}