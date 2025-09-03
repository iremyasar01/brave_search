import 'package:brave_search/presentations/news/widgets/news_meta_info.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

import 'package:flutter/material.dart';
class NewsContent extends StatelessWidget {
  final String title;
  final String description;
  final String? hostname;
  final String age;

  const NewsContent({
    super.key,
    required this.title,
    required this.description,
    this.hostname,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.3,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ).paddingBottom(8),

        // Açıklama (varsa)
        if (description.isNotEmpty)
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).paddingBottom(8),

        // Meta bilgiler
        NewsMetaInfo(hostname: hostname, age: age),
      ],
    );
  }
}