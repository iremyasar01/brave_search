import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import '../cubit/image_search_cubit.dart';
import '../cubit/image_search_state.dart';

class ImageSearchPaginationControls extends StatelessWidget {
  final ImageSearchState state;

  const ImageSearchPaginationControls({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalPages = state.totalPages;
    final currentPage = state.currentPage;

    // Maksimum 5 sayfa gösterilecek şekilde hesapla
    int startPage = currentPage - 2;
    int endPage = currentPage + 2;

    if (startPage < 1) {
      endPage += (1 - startPage);
      startPage = 1;
    }
    if (endPage > totalPages) {
      startPage -= (endPage - totalPages);
      endPage = totalPages;
    }
    if (startPage < 1) startPage = 1;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentPage > 1) ...[
              IconButton(
                icon: const Icon(Icons.first_page),
                color: Theme.of(context).iconTheme.color,
                onPressed: () => context.read<ImageSearchCubit>().loadPage(1),
                tooltip: 'İlk sayfa',
                iconSize: 20,
              ),
              const SizedBox(width: 4),
            ],

            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).iconTheme.color,
              onPressed: currentPage > 1
                  ? () => context.read<ImageSearchCubit>().loadPage(currentPage - 1)
                  : null,
              tooltip: 'Önceki sayfa',
              iconSize: 18,
            ),

            const SizedBox(width: 8),

            ...List.generate(
              endPage - startPage + 1,
              (index) {
                final pageNumber = startPage + index;
                final isCurrentPage = pageNumber == currentPage;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.read<ImageSearchCubit>().loadPage(pageNumber),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrentPage
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
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
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ).symmetricPadding(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 8),

            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: Theme.of(context).iconTheme.color,
              onPressed: currentPage < totalPages
                  ? () => context.read<ImageSearchCubit>().loadPage(currentPage + 1)
                  : null,
              tooltip: 'Sonraki sayfa',
              iconSize: 18,
            ),

            const SizedBox(width: 4),

            if (currentPage < totalPages) ...[
              IconButton(
                icon: const Icon(Icons.last_page),
                color: Theme.of(context).iconTheme.color,
                onPressed: () => context.read<ImageSearchCubit>().loadPage(totalPages),
                tooltip: 'Son sayfa',
                iconSize: 20,
              ),
            ],

            const SizedBox(width: 12),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$currentPage / $totalPages',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ).symmetricPadding(horizontal: 8, vertical: 4),
            ),
          ],
        ),
      ).symmetricPadding(horizontal: 16.0, vertical: 8.0),
    );
  }
}