import 'package:brave_search/common/widgets/bottomnavbar/modal_header.dart';
import 'package:brave_search/common/widgets/bottomnavbar/tabs_grid.dart';
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
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
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
              ElevatedButton.icon(
                onPressed: () {
                  onAddTab();
                  // Modal'ı kapatma - state değişikliği otomatik yansıyacak
                },
                icon: const Icon(Icons.add),
                label: const Text('Yeni Sekme'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}