import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/image_search_cubit.dart';
import '../cubit/image_search_state.dart';

class ImageSearchPaginationControls extends StatelessWidget {
  final ImageSearchState state;

  const ImageSearchPaginationControls({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: state.currentPage > 1
                ? () => context.read<ImageSearchCubit>().loadPage(state.currentPage - 1)
                : null,
          ),
          Text(
            'Sayfa ${state.currentPage} / ${state.totalPages}',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: state.currentPage < state.totalPages
                ? () => context.read<ImageSearchCubit>().loadPage(state.currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}