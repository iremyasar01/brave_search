import 'package:flutter/material.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class ImageSearchThumbnail extends StatelessWidget {
  final ImageSearchResult result;

  const ImageSearchThumbnail({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    // Görselin en-boy oranını hesapla
    final double aspectRatio = result.width > 0 && result.height > 0
        ? result.width / result.height
        : 1.0;

    // Minimum ve maksimum yükseklik belirle
    final double containerWidth = (MediaQuery.of(context).size.width - 24) / 2;
    final double imageHeight = containerWidth / aspectRatio;
    final double clampedImageHeight = imageHeight.clamp(120.0, 300.0);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: SizedBox(
        width: double.infinity,
        height: clampedImageHeight,
        child: Image.network(
          result.thumbnailUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: theme.colorScheme.surface,
            child: Icon(
              Icons.broken_image,
              size: 32,
              color: colors.iconSecondary,
            ).center(),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: theme.colorScheme.surface,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: theme.primaryColor,
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}