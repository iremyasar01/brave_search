import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class AddTabButton extends StatelessWidget {
  final AppColorsExtension colors;
  final VoidCallback onAddTab;

  const AddTabButton({super.key, 
    required this.colors,
    required this.onAddTab,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onAddTab,
      icon: Icon(Icons.add, color: colors.iconSecondary, size: 24),
    );
  }
}