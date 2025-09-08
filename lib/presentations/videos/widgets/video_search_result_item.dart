import 'package:brave_search/common/widgets/search/base_search_result_item.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:brave_search/domain/entities/video_search_result.dart';
import 'package:brave_search/presentations/videos/widgets/video_info.dart';
import 'package:brave_search/presentations/videos/widgets/video_thumbnail.dart';
import 'package:flutter/material.dart';

class VideoSearchResultItem extends BaseSearchResultItem {
  final VideoSearchResult result;

  VideoSearchResultItem({super.key, required this.result})
      : super(url: result.url, title: result.title);


  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
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
        children: [
          VideoThumbnail(
            thumbnailUrl: result.thumbnailUrl,
            duration: result.duration,
          ),
          VideoInfo(
            title: result.title,
            creator: result.creator,
            views: result.views,
            age: result.age,
            publisher: result.publisher,
          ).allPadding(12),
        ],
      ),
    );
  }
}