import 'package:brave_search/presentations/web/views/web_search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../web/cubit/web_search_cubit.dart';
import '../../web/cubit/web_search_state.dart';


class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case WebSearchStatus.initial:
            return const Center(
              child: Text(
                'Arama yapmak için üstteki çubuğu kullanın',
                style: TextStyle(color: Colors.white70),
              ),
            );
          case WebSearchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          case WebSearchStatus.empty:
            return const Center(
              child: Text(
                'Sonuç bulunamadı',
                style: TextStyle(color: Colors.white70),
              ),
            );
          case WebSearchStatus.failure:
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
          case WebSearchStatus.success:
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.results.length) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }
                
                return WebSearchResultItem(result: state.results[index]);
              },
            );
        }
      },
    );
  }
}