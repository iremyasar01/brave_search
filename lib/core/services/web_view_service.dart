import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class WebViewService {
  static void openInAppWebView(BuildContext context, {required String url, required String title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _InAppWebViewScreen(url: url, title: title),
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
                  _launchUrlExternal(url);
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

  static Future<void> _launchUrlExternal(String url) async {
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

class _InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const _InAppWebViewScreen({required this.url, required this.title});

  @override
  State<_InAppWebViewScreen> createState() => __InAppWebViewScreenState();
}

class __InAppWebViewScreenState extends State<_InAppWebViewScreen> {
  late final WebViewController _controller;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => WebViewService._launchUrlExternal(widget.url),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const LinearProgressIndicator(),
        ],
      ),
    );
  }
}