import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tab_grid_item.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter/material.dart';
class TabsGrid extends StatelessWidget {
  final BrowserState browserState;
  final Function(int) onTabTapped;
  final BuildContext parentContext;

  const TabsGrid({super.key, 
    required this.browserState,
    required this.onTabTapped,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return browserState.tabs.isEmpty
        ? Expanded(
            child: Center(
              child: Text(
                TabStrings.noneTab,
                style: TextStyle(color: colors.textHint),
              ),
            ),
          )
        : Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: browserState.tabs.length,
              itemBuilder: (context, index) => TabGridItem(
                browserState: browserState,
                index: index,
                onTabTapped: onTabTapped,
                parentContext: parentContext,
              ),
            ),
          );
  }
}