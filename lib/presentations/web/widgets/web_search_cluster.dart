import 'package:flutter/material.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class WebSearchCluster extends StatelessWidget {
  final List<WebCluster> cluster;

  const WebSearchCluster({super.key, required this.cluster});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İlgili bağlantılar:',
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ).spaceBottom(4),

        ...cluster.take(3).map((clusterItem) => 
          GestureDetector(
            onTap: () => _launchUrl(clusterItem.url),
            child: Row(
              children: [
                Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: colors.iconSecondary,
                ),
                Expanded(
                  child: Text(
                    clusterItem.title,
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
          ).onlyPadding(top: 4)
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}