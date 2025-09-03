import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class TabPreview extends StatelessWidget {
  final AppColorsExtension colors;

  const TabPreview({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.tabActiveBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(Icons.public, color: colors.accent, size: 48),
        ),
      ),
    );
  }
}
