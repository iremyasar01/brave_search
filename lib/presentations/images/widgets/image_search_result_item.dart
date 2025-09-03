import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:brave_search/presentations/images/widgets/image_search_content.dart';
import 'package:brave_search/presentations/images/widgets/image_search_thumbnail_widget.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSearchResultItem extends StatelessWidget {
  final ImageSearchResult result;

  const ImageSearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            ImageSearchThumbnail(result: result),
            ImageSearchContent(result: result),
          ],
        ),
      ).onlyMargin(bottom: 16), 
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}