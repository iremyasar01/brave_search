import 'package:brave_search/common/widgets/bottomnavbar/browser_menu_sheet.dart';
import 'package:brave_search/common/widgets/bottomnavbar/menu_button.dart';
import 'package:brave_search/common/widgets/bottomnavbar/navigation_button.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tab_counter.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tabs_overview_modal.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        return Container(
          color: colors.bottomNavBackground,
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
              // Center - Navigation Buttons
              NavigationButtons(
                onAddTab: onAddTab,
              ),
                // Tab Counter
              TabCounter(
                tabCount: browserState.tabs.length,
                onTap: () => _showTabsOverview(context, browserState),
              ),
              
              
              // Right - Menu
              MenuButton(
                onPressed: () => _showMenu(context, browserState),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMenu(BuildContext context, BrowserState browserState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => BrowserMenuSheet(browserState: browserState),
    );
  }

  void _showTabsOverview(BuildContext context, BrowserState browserState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => TabsOverviewModal(
        parentContext: context,
        onTabTapped: onTabTapped,
        onAddTab: onAddTab,
      ),
    );
  }
}