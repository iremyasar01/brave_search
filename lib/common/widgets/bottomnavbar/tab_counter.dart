import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class TabCounter extends StatelessWidget {
  final int tabCount;
  final VoidCallback onTap;

  const TabCounter({super.key, 
    required this.tabCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.bottomNavBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$tabCount',
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_up,
              color: colors.iconSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
