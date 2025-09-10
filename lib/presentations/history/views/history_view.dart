import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';
import 'package:brave_search/presentations/history/cubit/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class HistoryView extends StatefulWidget {
  // Arama sonucunu geri döndürmek için callback fonksiyonu
  final Function(String)? onSearchFromHistory;

  const HistoryView({super.key, this.onSearchFromHistory});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında önce eski kayıtları temizle, sonra geçmişi yükle
    _initializeHistory();
  }

  Future<void> _initializeHistory() async {
    final historyCubit = context.read<HistoryCubit>();
    await historyCubit.cleanOldHistory();
    await historyCubit.loadHistory();
  }

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
                      HistorySearchStrings.searchHistory,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OutlinedButton(
                    onPressed: () => _showClearAllDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide(color: colors.error ?? Colors.red),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(HistorySearchStrings.deleteAllHistory),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HistoryState state,
      ThemeData theme, AppColorsExtension colors) {
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
                    HistorySearchStrings.noHistory,
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      item.searchType == WebSearchStrings.web
                          ? Icons.public
                          : Icons.article,
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
                      onPressed: () =>
                          _showDeleteDialog(context, index, item.query),
                    ),
                    // HistoryView içinde:
                    onTap: () {
                      if (widget.onSearchFromHistory != null) {
                        widget.onSearchFromHistory!(
                            item.query); // Tıklanan query'yi gönder
                      }
                      Navigator.pop(context); // Sadece sayfayı kapat
                    },
                  ),
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
              //color: colors.error ?? Colors.red,
              size: 64,
            ).paddingBottom(16),
            Text(
              state.message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.error ?? Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<HistoryCubit>().loadHistory(),
              child: const Text(AppConstant.tryAgain),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  // Tarih formatla
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

  // Tek öğe silme onay dialogu
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
                        Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Tüm geçmişi silme onay dialogu
  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Tüm Geçmişi Sil'),
          content: const Text(
              'Tüm arama geçmişini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<HistoryCubit>().clearHistory();
              },
              child: Text(
                'Tümünü Sil',
                style: TextStyle(
                    color: Theme.of(context)
                            .extension<AppColorsExtension>()
                            ?.error ??
                        Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
