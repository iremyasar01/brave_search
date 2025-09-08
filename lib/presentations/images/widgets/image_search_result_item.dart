import 'package:brave_search/common/widgets/search/base_search_result_item.dart';
import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:brave_search/presentations/images/widgets/image_search_content.dart';
import 'package:brave_search/presentations/images/widgets/image_search_thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class ImageSearchResultItem extends BaseSearchResultItem {
  final ImageSearchResult result;

  ImageSearchResultItem({super.key, required this.result})
      : super(url: result.url, title: result.title);

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSearchThumbnail(result: result),
          ImageSearchContent(result: result),
        ],
      ),
    ).onlyMargin(bottom: 16);
  }
}