import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/image_search_result.dart';

class ImageSearchResultItem extends StatelessWidget {
  final ImageSearchResult result;

  const ImageSearchResultItem({super.key, required this.result});

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

    return GestureDetector(
      onTap: () => _launchUrl(result.url),
      child: Container(
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
            // Görsel
            ClipRRect(
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
                    ),
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
            ),
            
            // İçerik
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
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
                    ),
                  
                  const SizedBox(height: 6),
                  
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
              ),
            ),
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