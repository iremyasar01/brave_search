import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            color: colors.iconSecondary,
            size: 64,
          ).paddingBottom(16),
          Text(
            HistorySearchStrings.noHistory,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}