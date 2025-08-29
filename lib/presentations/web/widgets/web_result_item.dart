/*
// presentation/views/web/widgets/web_result_item.dart
import 'package:brave_search/app/data/models/web_search_response.dart';
import 'package:flutter/material.dart';
class WebResultItem extends StatelessWidget {
  final WebResult result;
  
  const WebResultItem({super.key, required this.result});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(result.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.metaUrl.hostname,
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 4),
          Text(result.description),
          if (result.age != null) ...[
            const SizedBox(height: 4),
            Text(
              result.age!,
              style: Theme.of(context).textTheme.overline,
            ),
          ],
        ],
      ),
      leading: result.thumbnail != null
          ? Image.network(result.thumbnail!.src, width: 50, height: 50)
          : const Icon(Icons.language),
      onTap: () => _openUrl(context, result.url),
    );
  }
  
  void _openUrl(BuildContext context, String url) {
    // URL açma işlemi
  }
}*/