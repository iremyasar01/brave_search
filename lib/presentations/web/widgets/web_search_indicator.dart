import 'package:flutter/material.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class WebSearchIndicators extends StatelessWidget {
  final WebSearchResult result;

  const WebSearchIndicators({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (result.language != null)
          Text(
            result.language!.toUpperCase(),
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          )
              .symmetricPadding(horizontal: 6, vertical: 2)
              .decorated(
                color: theme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),

        if (!result.familyFriendly) ...[
          const SizedBox(width: 8),
          Text(
            'NOT SAFE',
            style: TextStyle(
              color: theme.colorScheme.error,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          )
              .symmetricPadding(horizontal: 6, vertical: 2)
              .decorated(
                color: theme.colorScheme.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
        ],
      ],
    );
  }
}