import 'package:brave_search/common/widgets/bottomnavbar/tab_item_header.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tab_preview.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
class TabGridItem extends StatelessWidget {
  final BrowserState browserState;
  final int index;
  final Function(int) onTabTapped;
  final BuildContext parentContext;

  const TabGridItem({
    super.key,
    required this.browserState,
    required this.index,
    required this.onTabTapped,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    final tabId = browserState.tabs[index];
    final query = browserState.tabQueries[tabId] ?? 'Ana Sayfa';
    final isActive = index == browserState.activeTabIndex;

    return GestureDetector(
      onTap: () {
        onTabTapped(index);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.tabBackground,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.primaryColor, width: 2)
              : null,
        ),
        child: Column(
          children: [
            TabItemHeader(
              query: query,
              colors: colors,
              canClose: browserState.tabs.length > 1,
              onClose: () => _closeTab(context, index),
            ),
            TabPreview(colors: colors),
          ],
        ),
      ),
    );
  }

  void _closeTab(BuildContext context, int index) {
    if (index < browserState.tabs.length) {
      parentContext.read<BrowserCubit>().closeTab(index);
      if (browserState.tabs.length == 1) {
        Navigator.pop(context);
      }
    }
  }
}