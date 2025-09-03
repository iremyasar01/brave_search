import 'package:flutter/material.dart';

class SearchInitialWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const SearchInitialWidget({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) 
            Icon(icon, size: 64, color: theme.iconTheme.color?.withOpacity(0.6)),
          if (icon != null) 
            const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}