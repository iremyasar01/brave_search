import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/video_search_cubit.dart';
import '../cubit/video_search_state.dart';

class VideoSearchPaginationControls extends StatelessWidget {
  final VideoSearchState state;

  const VideoSearchPaginationControls({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = state.hasReachedMax ? state.currentPage : state.currentPage + 1;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: state.currentPage > 1
                ? () => context.read<VideoSearchCubit>().loadPage(state.currentPage - 1)
                : null,
          ),
          
          // Sayfa numaralarını göster
          ...List.generate(totalPages, (index) {
            final pageNumber = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () => context.read<VideoSearchCubit>().loadPage(pageNumber),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pageNumber == state.currentPage
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$pageNumber',
                    style: TextStyle(
                      color: pageNumber == state.currentPage
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            );
          }),
          
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: !state.hasReachedMax
                ? () => context.read<VideoSearchCubit>().loadPage(state.currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}