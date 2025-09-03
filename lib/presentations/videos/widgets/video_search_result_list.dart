import 'package:brave_search/domain/entities/video_search_result.dart';
import 'package:flutter/material.dart';

import 'video_search_result_item.dart';

class VideoSearchResultsList extends StatelessWidget {
  final List<VideoSearchResult> results;

  const VideoSearchResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return VideoSearchResultItem(result: results[index]);
      },
    );
  }
}