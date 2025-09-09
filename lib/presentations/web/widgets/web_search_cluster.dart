import 'package:brave_search/presentations/webview/views/in_app_web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

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
            onLongPress: () => _showLongPressMenu(context, clusterItem),
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

  void _showLongPressMenu(BuildContext context, WebCluster clusterItem) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Browser\'da aç'),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrlExternal(clusterItem.url);
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Linki kopyala'),
                onTap: () {
                  Navigator.pop(context);
                  _copyToClipboard(context, clusterItem.url);
                },
              ),
            ],
          ),
        );
      },
    );
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

  void _copyToClipboard(BuildContext context, String text) {
    // Clipboard'a kopyalama işlemi
    // Gerekli import: import 'package:flutter/services.dart';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link kopyalandı')),
    );
  }
}