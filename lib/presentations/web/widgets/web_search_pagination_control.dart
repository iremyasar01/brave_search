/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/web_search_cubit.dart';
import '../cubit/web_search_state.dart';

class WebSearchPaginationControls extends StatelessWidget {
  final WebSearchState state;

  const WebSearchPaginationControls({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    const maxPages = 10; // API sınırı
    final currentPage = state.currentPage;

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
                    onTap: isDisabled
                        ? null
                        : () {
                            //tıklanan sayfaya gitmesi için
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
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
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
}
*/