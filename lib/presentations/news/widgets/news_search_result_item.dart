import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:brave_search/presentations/news/widgets/news_content.dart';
import 'package:brave_search/presentations/news/widgets/news_thumbnail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class NewsSearchResultItem extends StatelessWidget {
  final NewsSearchResult result;

  const NewsSearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _launchUrl(result.url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: NewsContent(
                title: result.title,
                description: result.description,
                hostname: result.metaUrl?.hostname,
                age: result.age,
              ).allPadding(12), // Extension kullanımı
            ),

            // Sağ taraf - Küçük resim (varsa)
            if (result.thumbnail.src.isNotEmpty) ...[
              const SizedBox().spaceRight(12), // Extension kullanımı
              NewsThumbnailWidgets(
                src: result.thumbnail.src,
                publisher: result.metaUrl?.hostname,
              ).onlyPadding(
                  top: 12, right: 12, bottom: 12), // Extension kullanımı
            ],
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
