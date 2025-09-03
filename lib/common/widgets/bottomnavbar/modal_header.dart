import 'package:flutter/material.dart';
class ModalHeader extends StatelessWidget {
  final int tabCount;

  const ModalHeader({super.key, required this.tabCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$tabCount Gizli Sekme',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: theme.iconTheme.color),
        ),
      ],
    );
  }
}