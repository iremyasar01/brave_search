import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class EmptyBrowserState extends StatelessWidget {
  const EmptyBrowserState({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            isDark 
              ? 'assets/brave_color_lightbackground.png' 
              : 'assets/brave_color_darkbackground.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            'Brave Browser',
            style: TextStyle(
              color: appColors?.textHint ?? Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Gizliliğinizi koruyarak arama yapın',
            style: TextStyle(
              color: appColors?.textHint,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}