import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
class NavigationButtons extends StatelessWidget {
  final VoidCallback onAddTab;

  const NavigationButtons({super.key, 
    required this.onAddTab,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Row(
      children: [
        /*
        // Back button
        IconButton(
          onPressed: () {
            // Back navigation function
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.iconSecondary,
            size: 20,
          ),
        ),
        
        // Forward button  
        IconButton(
          onPressed: () {
            // Forward navigation function
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: colors.iconSecondary,
            size: 20,
          ),
        ),
        
        const SizedBox(width:32),
        */
        // Main + button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onAddTab,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}