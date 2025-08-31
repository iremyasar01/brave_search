import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/video_search_cubit.dart';
import '../cubit/video_search_state.dart';
import '../widgets/video_search_result_item.dart';

class VideosResultsView extends StatelessWidget {
  const VideosResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<VideoSearchCubit, VideoSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case VideoSearchStatus.initial:
            return Center(
              child: Text(
                'Video aramak için üstteki çubuğu kullanın',
                style: theme.textTheme.bodyMedium,
              ),
            );
          case VideoSearchStatus.loading:
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          case VideoSearchStatus.empty:
            return Center(
              child: Text(
                'Video bulunamadı',
                style: theme.textTheme.bodyMedium,
              ),
            );
          case VideoSearchStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: theme.colorScheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Bir hata oluştu',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? '',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          case VideoSearchStatus.success:
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.results.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(color: theme.primaryColor),
                    ),
                  );
                }
                
                return VideoSearchResultItem(result: state.results[index]);
              },
            );
        }
      },
    );
  }
}