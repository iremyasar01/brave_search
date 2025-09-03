import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class TabItemHeader extends StatelessWidget {
  final String query;
  final AppColorsExtension colors;
  final bool canClose;
  final VoidCallback onClose;

  const TabItemHeader({
    super.key,
    required this.query,
    required this.colors,
    required this.canClose,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Row(
        children: [
          Icon(Icons.public, color: colors.accent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              query.isEmpty ? 'Ana Sayfa' : query,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (canClose)
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.close, color: colors.iconSecondary, size: 16),
              ),
            ),
        ],
      ).allPadding(8),
    );
  }
}