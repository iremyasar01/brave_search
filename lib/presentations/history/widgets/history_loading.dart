import 'package:flutter/material.dart';


class MyHistoryLoading extends StatelessWidget {
  const MyHistoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: CircularProgressIndicator(color: theme.primaryColor),
    );
  }
}