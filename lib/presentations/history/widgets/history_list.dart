import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:brave_search/presentations/history/widgets/history_empty.dart';
import 'package:brave_search/presentations/history/widgets/history_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';

class HistoryList extends StatelessWidget {
  final List<SearchHistoryItem> history;
  final Function(String)? onSearchFromHistory;

  const HistoryList({
    super.key,
    required this.history,
    this.onSearchFromHistory,
  });

  @override
  Widget build(BuildContext context) {
    return history.isEmpty
        ? const HistoryEmpty()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return HistoryListItem(
                item: item,
                onTap: () {
                  if (onSearchFromHistory != null) {
                    onSearchFromHistory!(item.query);
                  }
                  Navigator.pop(context);
                },
                onDelete: () => _showDeleteDialog(context, index, item.query),
              );
            },
          );
  }

  void _showDeleteDialog(BuildContext context, int index, String query) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Geçmişten Sil'),
          content: Text(
              '"$query" aramasını geçmişten silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<HistoryCubit>().removeHistoryItem(index);
              },
              child: Text(
                'Sil',
                style: TextStyle(
                  color: Theme.of(context)
                          .extension<AppColorsExtension>()
                          ?.error ??
                      Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}