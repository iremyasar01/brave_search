import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class ClearHistoryButton extends StatelessWidget {
  final VoidCallback onClearAll;

  const ClearHistoryButton({super.key, required this.onClearAll});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OutlinedButton(
        onPressed: onClearAll,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.error,
          side: BorderSide(color: colors.error ?? Colors.red),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: const Text(HistorySearchStrings.deleteAllHistory),
      ),
    );
  }
}