import 'package:brave_search/common/widgets/bottomnavbar/menu_item.dart';
import 'package:brave_search/core/theme/theme_cubit.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';
import 'package:brave_search/presentations/history/views/history_view.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class BrowserMenuSheet extends StatelessWidget {
  final BrowserState browserState;

  const BrowserMenuSheet({super.key, 
    required this.browserState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.iconSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ).paddingBottom(20),
          
          // Menu title
          Text(
            'Tarayıcı Menüsü',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ).paddingBottom(20),
          
          // Theme toggle item
          MenuItem(
            context: context,
            icon: theme.brightness == Brightness.dark 
              ? Icons.light_mode 
              : Icons.dark_mode,
            title: 'Tema',
            subtitle: theme.brightness == Brightness.dark 
              ? 'Açık temaya geç' 
              : 'Koyu temaya geç',
            onTap: () {
              context.read<ThemeCubit>().toggleTheme();
              Navigator.pop(context);
            },
            colors: colors,
          ),
          
          // History item
          MenuItem(
            context: context,
            icon: Icons.history,
            title: 'Geçmiş',
            subtitle: 'Arama geçmişini görüntüle',
            onTap: () {
              Navigator.pop(context);
              _showHistory(context);
            },
            colors: colors,
          ),
        ],
      ),
    );
  }
   void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: context.read<HistoryCubit>()..loadHistory(),
          child: const HistoryView(),
        );
      },
    );
  }
}