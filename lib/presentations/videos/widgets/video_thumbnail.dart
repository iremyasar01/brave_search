import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class VideoThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  final String duration;

  const VideoThumbnail({
    super.key,
    required this.thumbnailUrl,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>();

    return Stack(
      children: [
        // Thumbnail Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            thumbnailUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: theme.cardColor.withOpacity(0.5),
              child: Icon(
                Icons.videocam_off,
                size: 48,
                color: colors?.iconSecondary ?? theme.disabledColor,
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: theme.cardColor.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),

        // Duration Badge
        Positioned(
          bottom: 8,
          right: 8,
          child: Text(
            duration,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
              .symmetricPadding(horizontal: 6, vertical: 2)
              .decorated(
                color: theme.colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
        ),

        // Play Icon
        Positioned(
          bottom: 8,
          left: 8,
          child: Icon(
            Icons.play_arrow,
            color: theme.colorScheme.onPrimary,
            size: 16,
          )
              .symmetricPadding(horizontal: 6, vertical: 2)
              .decorated(
                color: theme.colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
        ),
      ],
    );
  }
}