import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SearchErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final String errorTitle;
  final String buttonText;
  final VoidCallback onRetry;
  final IconData? icon;

  const SearchErrorWidget({
    super.key,
    required this.errorMessage,
    required this.errorTitle,
    required this.buttonText,
    required this.onRetry,
    this.icon = Icons.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorTitle,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (errorMessage != null && errorMessage!.isNotEmpty)
            Text(
              errorMessage!,
              style: TextStyle(
                color: colors?.textHint,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}