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
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(color: theme.primaryColor),
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