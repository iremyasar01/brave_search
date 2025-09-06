import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';


class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MenuButton({super.key, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.more_vert,
        color: colors.iconSecondary,
        size: 24,
      ),
    );
  }
}

