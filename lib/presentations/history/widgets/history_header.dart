import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget {
  final VoidCallback onClose;

  const HistoryHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Container(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.bottomNavBorder.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            HistorySearchStrings.searchHistory,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, color: theme.iconTheme.color),
          ),
        ],
      ),
    );
  }
}