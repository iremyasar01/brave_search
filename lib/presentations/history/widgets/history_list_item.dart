import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:flutter/material.dart';


class HistoryListItem extends StatelessWidget {
  final SearchHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Function(String, String)? onSearchFromHistory; 

  const HistoryListItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.onSearchFromHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          item.searchType == 'web'
              ? Icons.public
              : item.searchType == 'images'
                  ? Icons.image
                  : item.searchType == 'videos'
                      ? Icons.video_library
                      : item.searchType == 'news'
                          ? Icons.article
                          : Icons.search,
          color: colors.iconSecondary,
        ),
        title: Text(
          item.query,
          style: theme.textTheme.bodyLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDateTime(item.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textHint,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: colors.iconSecondary,
            size: 20,
          ),
          onPressed: onDelete,
        ),
        onTap: () {
          // Close all modals
          Navigator.of(context).popUntil((route) => route.isFirst);
          
          // Call the callback function to perform search in the main context
          if (onSearchFromHistory != null) {
            onSearchFromHistory!(item.query, item.searchType);
          }
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String timeStr =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (itemDate == today) {
      return 'Bugün $timeStr';
    } else if (itemDate == yesterday) {
      return 'Dün $timeStr';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} $timeStr';
    }
  }
}