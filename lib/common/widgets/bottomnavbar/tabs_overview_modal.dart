import 'package:brave_search/common/widgets/bottomnavbar/add_tab_button_large.dart';
import 'package:brave_search/common/widgets/bottomnavbar/modal_header.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tabs_grid.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class TabsOverviewModal extends StatelessWidget {
  final BuildContext parentContext;
  final Function(int) onTabTapped;
  final VoidCallback onAddTab;

  const TabsOverviewModal({
    super.key,
    required this.parentContext,
    required this.onTabTapped,
    required this.onAddTab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      bloc: parentContext.read<BrowserCubit>(),
      builder: (context, currentBrowserState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              ModalHeader(
                tabCount: currentBrowserState.tabs.length,
              ),
              const SizedBox(height: 16),
              TabsGrid(
                browserState: currentBrowserState,
                onTabTapped: onTabTapped,
                parentContext: parentContext,
              ),
              const SizedBox(height: 16),
              AddTabButtonLarge(
                onAddTab: onAddTab,
              ),
            ],
          ).allPadding(16),
        );
      },
    );
  }
}