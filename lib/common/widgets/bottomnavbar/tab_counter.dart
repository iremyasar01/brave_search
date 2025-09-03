import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class TabCounter extends StatelessWidget {
  final BrowserState browserState;

  const TabCounter({super.key, required this.browserState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.bottomNavBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${browserState.tabs.length}',
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
      )
          .symmetricPadding(horizontal: 12, vertical: 6)
          .symmetricMargin(horizontal: 12),
    );
  }
}