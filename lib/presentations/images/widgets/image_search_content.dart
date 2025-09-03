import 'package:flutter/material.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class ImageSearchContent extends StatelessWidget {
  final ImageSearchResult result;

  const ImageSearchContent({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        if (result.title.isNotEmpty)
          Text(
            result.title,
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).paddingBottom(6),
        
        // Kaynak ve boyutlar
        Row(
          children: [
            Expanded(
              child: Text(
                result.source,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${result.width}×${result.height}',
              style: TextStyle(
                color: colors.textHint,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    ).allPadding(12);
  }
}