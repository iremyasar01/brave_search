import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/theme/theme_extensions.dart';
import '../cubit/image_search_cubit.dart';
import '../cubit/image_search_state.dart';
import '../widgets/image_search_result_item.dart';

class ImagesResultsView extends StatelessWidget {
  const ImagesResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return BlocBuilder<ImageSearchCubit, ImageSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            // Sayfa navigasyonu
            if (state.status == ImageSearchStatus.success)
              _buildPaginationControls(context, state),
            
            Expanded(
              child: _buildContent(context, state, theme, colors),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaginationControls(BuildContext context, ImageSearchState state) {
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

  Widget _buildContent(BuildContext context, ImageSearchState state, ThemeData theme, AppColorsExtension colors) {
    switch (state.status) {
      case ImageSearchStatus.initial:
        return Center(
          child: Text(
            'Görsel aramak için üstteki çubuğu kullanın',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
        );
      case ImageSearchStatus.loading:
        return Center(
          child: CircularProgressIndicator(color: theme.primaryColor),
        );
      case ImageSearchStatus.empty:
        return Center(
          child: Text(
            'Görsel bulunamadı',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
        );
      case ImageSearchStatus.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error, 
                color: theme.colorScheme.error, 
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Bir hata oluştu',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color, 
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? '',
                style: TextStyle(
                  color: colors.textHint, 
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<ImageSearchCubit>().searchImages(state.query),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        );
      case ImageSearchStatus.success:
        return MasonryGridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: state.results.length,
          itemBuilder: (context, index) {
            return ImageSearchResultItem(result: state.results[index]);
          },
        );
    }
  }
}