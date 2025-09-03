import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_extensions.dart';
import '../cubit/web_search_cubit.dart';
import '../cubit/web_search_state.dart';
import '../widgets/web_search_result_item.dart';

class WebResultsView extends StatelessWidget {
  const WebResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return BlocBuilder<WebSearchCubit, WebSearchState>(
      builder: (context, state) {
        return Column(
          children: [
            // Sayfa navigasyonu
            if (state.status == WebSearchStatus.success)
              _buildPaginationControls(context, state),
            
            Expanded(
              child: _buildContent(context, state, theme, colors),
            ),
          ],
        );
      },
    );
  }
Widget _buildPaginationControls(BuildContext context, WebSearchState state) {
  const maxPages = 10; // API sınırı
  final currentPage = state.currentPage;
  
  // Debug bilgileri
  print('=== Pagination Debug ===');
  print('Current Page: $currentPage');
  print('Has Reached Max: ${state.hasReachedMax}');
  print('Results Count: ${state.results.length}');
  print('Max Pages: $maxPages');
  print('========================');
  
  // Gösterilecek sayfa aralığını hesapla
  int startPage = (currentPage - 2).clamp(1, maxPages);
  int endPage = (currentPage + 2).clamp(1, maxPages);
  
  // Eğer son sayfaya ulaşıldıysa, endPage'i güncelle
  if (state.hasReachedMax && currentPage < maxPages) {
    endPage = currentPage;
  }
  
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // İlk sayfa butonu
        if (currentPage > 1) ...[
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: () {
              print('Going to first page');
              context.read<WebSearchCubit>().loadPage(1);
            },
            tooltip: 'İlk sayfa',
          ),
          const SizedBox(width: 4),
        ],
        
        // Önceki sayfa butonu
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: currentPage > 1
              ? () {
                  print('Going to previous page: ${currentPage - 1}');
                  context.read<WebSearchCubit>().loadPage(currentPage - 1);
                }
              : null,
          tooltip: 'Önceki sayfa',
        ),
        
        const SizedBox(width: 8),
        
        // Sayfa numaraları
        ...List.generate(
          endPage - startPage + 1,
          (index) {
            final pageNumber = startPage + index;
            final isCurrentPage = pageNumber == currentPage;
            final isDisabled = pageNumber > maxPages || 
                             (state.hasReachedMax && pageNumber > currentPage);
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled ? null : () {
                    print('Going to page: $pageNumber');
                    context.read<WebSearchCubit>().loadPage(pageNumber);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrentPage
                          ? Theme.of(context).primaryColor
                          : isDisabled 
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrentPage
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Text(
                      '$pageNumber',
                      style: TextStyle(
                        color: isCurrentPage
                            ? Colors.white
                            : isDisabled
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: isCurrentPage
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(width: 8),
        
        // Sonraki sayfa butonu
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: (currentPage < maxPages && !state.hasReachedMax)
              ? () {
                  print('Going to next page: ${currentPage + 1}');
                  context.read<WebSearchCubit>().loadPage(currentPage + 1);
                }
              : null,
          tooltip: 'Sonraki sayfa',
        ),
        
        const SizedBox(width: 4),
        
        // Son sayfa butonu (sadece mevcut sayfa son sayfa değilse)
        if (currentPage < maxPages && !state.hasReachedMax) ...[
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: () {
              print('Going to last available page: $maxPages');
              context.read<WebSearchCubit>().loadPage(maxPages);
            },
            tooltip: 'Son sayfa',
          ),
        ],
        
        // Sayfa bilgisi
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$currentPage / ${state.hasReachedMax ? currentPage : maxPages}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildContent(BuildContext context, WebSearchState state, ThemeData theme, AppColorsExtension colors) {
    switch (state.status) {
      case WebSearchStatus.initial:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search, 
                size: 64, 
                color: theme.iconTheme.color?.withOpacity(0.6),
              ),
              const SizedBox(height: 16),
              Text(
                'Arama yapmak için üstteki çubuğu kullanın',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      case WebSearchStatus.loading:
        return Center(
          child: CircularProgressIndicator(color: theme.primaryColor),
        );
      case WebSearchStatus.empty:
        return Center(
          child: Text(
            'Sonuç bulunamadı',
            style: theme.textTheme.bodyMedium,
          ),
        );
      case WebSearchStatus.failure:
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
                onPressed: () => context.read<WebSearchCubit>().searchWeb(state.query),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        );
      case WebSearchStatus.success:
        if (state.results.isEmpty) {
          return Center(
            child: Text(
              'Hiç sonuç bulunamadı',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.results.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: WebSearchResultItem(result: state.results[index]),
            );
          },
        );
    }
  }
}