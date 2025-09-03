import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class WebSearchErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const WebSearchErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: theme.colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? '',
            style: TextStyle(
              color: colors.textHint,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}