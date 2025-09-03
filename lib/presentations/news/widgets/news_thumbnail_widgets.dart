
import 'package:flutter/material.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class NewsThumbnailWidgets extends StatelessWidget {
  final String src;
  final String? publisher;

  const NewsThumbnailWidgets({
    super.key,
    required this.src,
    this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>();

    return SizedBox(
      width: 80,
      height: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          src,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildErrorState(theme, colors),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingState(theme, loadingProgress);
          },
        ),
      ),
    ).rounded8();
  }

  Widget _buildErrorState(ThemeData theme, AppColorsExtension? colors) {
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article,
            size: 24,
            color: colors?.iconSecondary ?? theme.disabledColor,
          ).paddingBottom(4),
          if (publisher != null)
            Text(
              publisher!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors?.textHint ?? theme.hintColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, ImageChunkEvent? loadingProgress) {
    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: loadingProgress?.expectedTotalBytes != null
                ? loadingProgress!.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            color: theme.primaryColor,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}