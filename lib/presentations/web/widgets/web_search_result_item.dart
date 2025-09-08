import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/presentations/web/widgets/in_app_web_view_screen.dart';
import 'package:brave_search/presentations/web/widgets/web_search_cluster.dart';
import 'package:brave_search/presentations/web/widgets/web_search_indicator.dart';
import 'package:brave_search/presentations/web/widgets/web_search_top_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';


class WebSearchResultItem extends StatelessWidget {
  final WebSearchResult result;

  const WebSearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // URL, favicon and profile info
          WebSearchTopRow(result: result).allPadding(12),
          
          // Title
          GestureDetector(
            onTap: () => _openInAppWebView(context, result),
            onLongPress: () => _showContextMenu(context, result),
            child: Text(
              result.title,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ).symmetricPadding(horizontal: 12),
          ),
          
          // Description
          GestureDetector(
            onTap: () => _openInAppWebView(context, result),
            onLongPress: () => _showContextMenu(context, result),
            child: Text(
              result.description,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ).allPadding(12),
          ),
          
          // Language and family friendly indicators
          if (result.language != null || !result.familyFriendly)
            WebSearchIndicators(result: result)
                .onlyPadding(left: 12, right: 12, bottom: 8),
          
          // Cluster results (related links)
          if (result.cluster != null && result.cluster!.isNotEmpty)
            WebSearchCluster(cluster: result.cluster!)
                .symmetricPadding(horizontal: 12, vertical: 8),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context, WebSearchResult result) {
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
      items: [
        PopupMenuItem(
          value: 'browser',
          child: Row(
            children: [
              const Icon(Icons.open_in_browser, size: 20),
              const SizedBox(width: 8),
              Text('Browser\'da aç'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'browser') {
        _launchUrlExternal(result.url);
      }
    });
  }

  Future<void> _launchUrlExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openInAppWebView(BuildContext context, WebSearchResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InAppWebViewScreen(
          url: result.url,
          title: result.title,
        ),
      ),
    );
  }
}