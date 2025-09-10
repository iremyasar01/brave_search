import 'package:flutter/material.dart';
class GenericSearchResultsList<T> extends StatelessWidget {
  final List<T> results;
  final Widget Function(T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  const GenericSearchResultsList({
    super.key,
    required this.results,
    required this.itemBuilder,
    this.scrollController,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController, 
      padding: padding,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return itemBuilder(results[index], index);
      },
    );
  }
}