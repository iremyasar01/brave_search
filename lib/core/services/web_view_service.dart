import 'package:brave_search/presentations/web/widgets/in_app_web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class WebViewService {
  static void openInAppWebView(BuildContext context, {required String url, required String title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InAppWebViewScreen(url: url, title: title),
      ),
    );
  }

  static void showLinkContextMenu(BuildContext context, {required String url, required String title}) {
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
                  launchUrlExternal(url);
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Linki kopyala'),
                onTap: () {
                  Navigator.pop(context);
                  _copyToClipboard(context, url);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> launchUrlExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link kopyalandı')),
    );
  }
}
