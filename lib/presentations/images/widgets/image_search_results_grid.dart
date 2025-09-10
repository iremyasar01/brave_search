import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/image_search_result_item.dart';

class ImageSearchResultsGrid extends StatelessWidget {
  final List<ImageSearchResult> results;
  final ScrollController? scrollController;

  const ImageSearchResultsGrid({
    super.key, 
    required this.results,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: scrollController, // ScrollController'ı burada kullan
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ImageSearchResultItem(result: results[index]);
      },
    );
  }
}