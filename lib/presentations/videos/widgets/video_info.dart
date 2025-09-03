import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class VideoInfo extends StatelessWidget {
  final String title;
  final String creator;
  final int views;
  final String age;
  final String publisher;

  const VideoInfo({
    super.key,
    required this.title,
    required this.creator,
    required this.views,
    required this.age,
    required this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: theme.textTheme.bodyLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ).paddingBottom(8),

        // Creator and views
        Row(
          children: [
            Expanded(
              child: Text(
                creator,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors?.textHint ?? theme.hintColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (views > 0) ...[
              const SizedBox().spaceRight(8),
              Text(
                '${_formatViews(views)} görüntüleme',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors?.textHint ?? theme.hintColor,
                ),
              ),
            ],
          ],
        ).paddingBottom(4),

        // Age and publisher
        Row(
          children: [
            Expanded(
              child: Text(
                age,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors?.textHint ?? theme.hintColor,
                ),
              ),
            ),
            Text(
              publisher,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors?.textHint ?? theme.hintColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}