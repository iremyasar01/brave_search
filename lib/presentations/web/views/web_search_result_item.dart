import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/web_search_result.dart';

class WebSearchResultItem extends StatelessWidget {
  final WebSearchResult result;

  const WebSearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // URL, favicon and profile info
          Row(
            children: [
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
          ),
          const SizedBox(height: 8),
          
          // Title
          GestureDetector(
            onTap: () => _launchUrl(result.url),
            child: Text(
              result.title,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          
          // Description
          Text(
            result.description,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Language and family friendly indicators
          if (result.language != null || !result.familyFriendly)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  if (result.language != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        result.language!.toUpperCase(),
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!result.familyFriendly) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'NOT SAFE',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          
          // Cluster results (related links)
          if (result.cluster != null && result.cluster!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İlgili bağlantılar:',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...result.cluster!.take(3).map((cluster) => 
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: GestureDetector(
                        onTap: () => _launchUrl(cluster.url),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chevron_right,
                              size: 12,
                              color: colors.iconSecondary,
                            ),
                            Expanded(
                              child: Text(
                                cluster.title,
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}