import 'package:flutter/material.dart';
import 'package:brave_search/core/services/web_view_service.dart';

abstract class BaseSearchResultItem extends StatelessWidget {
  final String url;
  final String title;

  const BaseSearchResultItem({
    super.key,
    required this.url,
    required this.title,
  });

  @protected
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => WebViewService.openInAppWebView(
        context, 
        url: url, 
        title: title
      ),
      onLongPress: () => WebViewService.showLinkContextMenu(
        context, 
        url: url, 
        title: title
      ),
      child: buildContent(context),
    );
  }
}