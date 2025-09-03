import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
class NewsMetaInfo extends StatelessWidget {
  final String? hostname;
  final String age;

  const NewsMetaInfo({
    super.key,
    this.hostname,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>();

    return Row(
      children: [
        // Kaynak ismi (kırmızı logo ile)
        if (hostname != null) ...[
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox().spaceRight(6),
          Text(
            hostname!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        // Ayırıcı
        if (hostname != null && age.isNotEmpty) ...[
          Text(
            ' | ',
            style: TextStyle(
              color: colors?.textHint ?? theme.hintColor,
              fontSize: 12,
            ),
          ).paddingHorizontal(4),
        ],

        // Tarih
        if (age.isNotEmpty)
          Text(
            age,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors?.textHint ?? theme.hintColor,
            ),
          ),
      ],
    );
  }
}