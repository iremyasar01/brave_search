import 'package:flutter/material.dart';
class WebSearchLoadingWidget extends StatelessWidget {
  const WebSearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: CircularProgressIndicator(color: theme.primaryColor),
    );
  }
}