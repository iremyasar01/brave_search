import 'package:flutter/material.dart';
class AppLoadingIndicator extends StatelessWidget {
  final Color? color;
  
  const AppLoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: CircularProgressIndicator(color: color ?? theme.primaryColor),
    );
  }
}