import 'package:brave_search/presentations/web/widgets/in_app_web_view_screen.dart';
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
            onTap: () => _openInAppWebView(context, clusterItem),
            onLongPress: () => _showContextMenu(context, clusterItem),
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

  void _showContextMenu(BuildContext context, WebCluster clusterItem) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset(overlay.size.width / 2, overlay.size.height / 2),
          Offset(overlay.size.width / 2, overlay.size.height / 2),
        ),
        Offset.zero & overlay.size,
      ),
      items:const [
        PopupMenuItem(
          value: 'browser',
          child: Row(
            children: [
               Icon(Icons.open_in_browser, size: 20),
               SizedBox(width: 8),
              Text('Browser\'da aç'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'browser') {
        _launchUrlExternal(clusterItem.url);
      }
    });
  }

  Future<void> _launchUrlExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openInAppWebView(BuildContext context, WebCluster clusterItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InAppWebViewScreen(
          url: clusterItem.url,
          title: clusterItem.title,
        ),
      ),
    );
  }
}