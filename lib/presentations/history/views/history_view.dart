// history_view.dart
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';
import 'package:brave_search/presentations/history/cubit/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colors.bottomNavBorder.withOpacity(0.3),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Arama Geçmişi',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: theme.iconTheme.color),
                    ),
                  ],
                ),
              ),
              
              // History list
              Expanded(
                child: _buildContent(context, state, theme, colors),
              ),
              
              // Clear all button
              if (state is HistoryLoaded && state.history.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OutlinedButton(
                    onPressed: () => context.read<HistoryCubit>().clearHistory(),
                    style: OutlinedButton.styleFrom(
                      //foregroundColor: colors.error,
                      //side: BorderSide(color: colors.error),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Tüm Geçmişi Temizle'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HistoryState state, ThemeData theme, AppColorsExtension colors) {
    if (state is HistoryLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.primaryColor),
      );
    } else if (state is HistoryLoaded) {
      final history = state.history;
      return history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    color: colors.iconSecondary,
                    size: 64,
                  ).paddingBottom(16),
                  Text(
                    'Henüz arama geçmişi yok',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.textHint,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  leading: Icon(
                    item.searchType == 'web' 
                      ? Icons.public 
                      : Icons.article,
                    color: colors.iconSecondary,
                  ),
                  title: Text(
                    item.query,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
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
                    onPressed: () => context.read<HistoryCubit>().removeHistoryItem(index, history),
                  ),
                  onTap: () {
                    // Bu aramayı yeniden yüklemek için gerekli işlemler
                    Navigator.pop(context, item.query);
                  },
                );
              },
            );
    } else if (state is HistoryError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              //color: colors.error,
              size: 64,
            ).paddingBottom(16),
            Text(
              state.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                //color: colors.error,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => context.read<HistoryCubit>().loadHistory(),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Varsayılan durum
    }
  }
}