import 'package:brave_search/core/services/web_view_service.dart';
import 'package:flutter/material.dart';

class WebViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String url;

  const WebViewAppBar({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.open_in_browser),
          onPressed: () => WebViewService.launchUrlExternal(url),
        ),
      ],
    );
  }
}