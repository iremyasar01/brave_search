import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
class MyFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MyFilterChip({super.key, 
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontSize: 14,
          ),
        ).symmetricPadding(horizontal: 16),
      ).onlyPadding(right: 12),
    );
  }
}