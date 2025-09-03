import 'package:flutter/material.dart';
class WebSearchEmptyWidget extends StatelessWidget {
  const WebSearchEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Text(
        'Sonuç bulunamadı',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}