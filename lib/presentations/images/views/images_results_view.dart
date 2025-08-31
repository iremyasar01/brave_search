import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../cubit/image_search_cubit.dart';
import '../cubit/image_search_state.dart';
import '../widgets/image_search_result_item.dart';

class ImagesResultsView extends StatelessWidget {
  const ImagesResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageSearchCubit, ImageSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case ImageSearchStatus.initial:
            return const Center(
              child: Text(
                'Görsel aramak için üstteki çubuğu kullanın',
                style: TextStyle(color: Colors.white70),
              ),
            );
          case ImageSearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          case ImageSearchStatus.empty:
            return const Center(
              child: Text(
                'Görsel bulunamadı',
                style: TextStyle(color: Colors.white70),
              ),
            );
          case ImageSearchStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Bir hata oluştu',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? '',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          case ImageSearchStatus.success:
            return MasonryGridView.count(
              padding: const EdgeInsets.all(8),
              crossAxisCount: 2, // 2 sütun
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: state.results.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.results.length) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  );
                }
                
                return ImageSearchResultItem(result: state.results[index]);
              },
            );
        }
      },
    );
  }
}