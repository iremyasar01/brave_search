import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:brave_search/domain/entities/video_search_result.dart';
import 'package:brave_search/presentations/videos/widgets/video_info.dart';
import 'package:brave_search/presentations/videos/widgets/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class VideoSearchResultItem extends StatelessWidget {
  final VideoSearchResult result;

  const VideoSearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _launchUrl(result.url),
      child: Container(
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
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}