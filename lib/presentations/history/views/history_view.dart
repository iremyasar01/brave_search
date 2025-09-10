import 'package:brave_search/presentations/history/widgets/clear_history_button.dart';
import 'package:brave_search/presentations/history/widgets/history_error.dart';
import 'package:brave_search/presentations/history/widgets/history_header.dart';
import 'package:brave_search/presentations/history/widgets/history_list.dart';
import 'package:brave_search/presentations/history/widgets/history_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';
import 'package:brave_search/presentations/history/cubit/history_state.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';

class HistoryView extends StatefulWidget {
  final Function(String)? onSearchFromHistory;

  const HistoryView({super.key, this.onSearchFromHistory});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    _initializeHistory();
  }

  Future<void> _initializeHistory() async {
    final historyCubit = context.read<HistoryCubit>();
    await historyCubit.cleanOldHistory();
    await historyCubit.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        children: [
          HistoryHeader(
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const MyHistoryLoading();
                } else if (state is HistoryLoaded) {
                  return HistoryList(
                    history: state.history,
                    onSearchFromHistory: widget.onSearchFromHistory,
                  );
                } else if (state is HistoryError) {
                  return MyHistoryError(message: state.message);
                } else {
                  return Container();
                }
              },
            ),
          ),
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoaded && state.history.isNotEmpty) {
                return ClearHistoryButton(
                  onClearAll: () => _showClearAllDialog(context),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

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
