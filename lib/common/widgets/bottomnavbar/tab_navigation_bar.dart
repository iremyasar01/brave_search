import 'package:brave_search/common/widgets/bottomnavbar/add_tab_button.dart';
import 'package:brave_search/common/widgets/bottomnavbar/home_button.dart';
import 'package:brave_search/common/widgets/bottomnavbar/menu_button.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tab_counter.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tabs_overview_modal.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class TabNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;
  final VoidCallback onAddTab;

  const TabNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
    required this.onAddTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        return Container(
          color: colors.bottomNavBackground,
          child: Row(
            children: [
              TabCounter(browserState: browserState),
              const Spacer(),
              HomeButton(colors: colors),
              AddTabButton(colors: colors, onAddTab: onAddTab),
              MenuButton(
                colors: colors,
                onPressed: () => _showTabsOverview(context, browserState),
              ),
            ],
          ).symmetricPadding(vertical: 8),
        );
      },
    );
  }

  void _showTabsOverview(BuildContext context, BrowserState initialBrowserState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (modalContext) => TabsOverviewModal(
        parentContext: context,
        onTabTapped: onTabTapped,
        onAddTab: onAddTab,
      ),
    );
  }
}












