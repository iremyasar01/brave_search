import 'package:flutter/material.dart';
class WebSearchInitialWidget extends StatelessWidget {
  const WebSearchInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: theme.iconTheme.color?.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Arama yapmak için üstteki çubuğu kullanın',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}