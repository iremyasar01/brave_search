import 'package:brave_search/common/widgets/add_tab_button_large.dart';
import 'package:brave_search/common/widgets/modal_header.dart';
import 'package:brave_search/common/widgets/tabs_grid.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
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
          ),
        );
      },
    );
  }
}