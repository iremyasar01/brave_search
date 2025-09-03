import 'package:flutter/material.dart';
class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  
  const AppEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: theme.iconTheme.color?.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}