import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/constant/asset_constants.dart';
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
                ? AssetConstants.braveColorDark
                : AssetConstants.braveColorLight,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            AppConstant.braveSearchBrowser,
            style: TextStyle(
              color: appColors?.textHint ??
                  Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppConstant.slogan,
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
