import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/news_search_cubit.dart';
import '../cubit/news_search_state.dart';
import '../widgets/news_search_result_item.dart';

class NewsResultsView extends StatelessWidget {
  const NewsResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<NewsSearchCubit, NewsSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case NewsSearchStatus.initial:
            return Center(
              child: Text(
                'Haber aramak için üstteki çubuğu kullanın',
                style: theme.textTheme.bodyMedium,
              ),
            );
          case NewsSearchStatus.loading:
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          case NewsSearchStatus.empty:
            return Center(
              child: Text(
                'Haber bulunamadı',
                style: theme.textTheme.bodyMedium,
              ),
            );
          case NewsSearchStatus.failure:
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
          case NewsSearchStatus.success:
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
                
                return NewsSearchResultItem(result: state.results[index]);
              },
            );
        }
      },
    );
  }
}