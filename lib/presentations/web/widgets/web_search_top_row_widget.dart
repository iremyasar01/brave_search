import 'package:flutter/material.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';


class WebSearchTopRow extends StatelessWidget {
  final WebSearchResult result;

  const WebSearchTopRow({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Row(
      children: [
        // Favicon or profile image
        if (result.profile?.img != null)
          Image.network(
            result.profile!.img!,
            width: 16,
            height: 16,
            errorBuilder: (_, __, ___) => Icon(
              Icons.public,
              size: 16,
              color: colors.iconSecondary,
            ),
          )
        else if (result.favicon != null)
          Image.network(
            result.favicon!,
            width: 16,
            height: 16,
            errorBuilder: (_, __, ___) => Icon(
              Icons.public,
              size: 16,
              color: colors.iconSecondary,
            ),
          )
        else
          Icon(
            Icons.public,
            size: 16,
            color: colors.iconSecondary,
          ),

        const SizedBox(width: 8),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.profile?.longName != null)
                Text(
                  result.profile!.longName,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                result.url,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        if (result.pageAge != null)
          Text(
            result.pageAge!,
            style: TextStyle(
              color: colors.textHint,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}