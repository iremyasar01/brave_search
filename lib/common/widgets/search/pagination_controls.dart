import 'package:flutter/material.dart';

class GenericPaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasReachedMax;
  final Function(int) onPageChanged;
  final int maxPages;

  const GenericPaginationControls({
    super.key,
    required this.currentPage,
    required this.hasReachedMax,
    required this.onPageChanged,
    required this.maxPages,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = hasReachedMax ? currentPage : maxPages;
    
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);

    if (hasReachedMax && currentPage < maxPages) {
      endPage = currentPage;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                onPressed: () => onPageChanged(1),
                tooltip: 'İlk sayfa',
                iconSize: 20,
              ),
              const SizedBox(width: 4),
            ],

            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).iconTheme.color,
              onPressed: currentPage > 1
                  ? () => onPageChanged(currentPage - 1)
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
                final isDisabled = pageNumber > totalPages;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isDisabled ? null : () => onPageChanged(pageNumber),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCurrentPage
                              ? Theme.of(context).primaryColor
                              : isDisabled
                                  ? Theme.of(context).disabledColor.withOpacity(0.3)
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
                                : isDisabled
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
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
              onPressed: (currentPage < totalPages && !hasReachedMax)
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              tooltip: 'Sonraki sayfa',
              iconSize: 18,
            ),

            const SizedBox(width: 4),

            if (currentPage < totalPages && !hasReachedMax) ...[
              IconButton(
                icon: const Icon(Icons.last_page),
                color: Theme.of(context).iconTheme.color,
                onPressed: () => onPageChanged(totalPages),
                tooltip: 'Son sayfa',
                iconSize: 20,
              ),
            ],

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
