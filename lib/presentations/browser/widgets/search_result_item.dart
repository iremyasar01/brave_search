/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/search_result.dart';

class SearchResultItem extends StatelessWidget {
  final SearchResult result;

  const SearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // URL and favicon
          Row(
            children: [
              if (result.favicon != null)
                Image.network(
                  result.favicon!,
                  width: 16,
                  height: 16,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.public,
                    size: 16,
                    color: Colors.white54,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.url,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Title
          GestureDetector(
            onTap: () => _launchUrl(result.url),
            child: Text(
              result.title,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Description
          Text(
            result.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
*/