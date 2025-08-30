import 'package:brave_search/common/widgets/tab_indicator.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class TabNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;
  final VoidCallback onAddTab;

  const TabNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
    required this.onAddTab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        return Container(
          color: Colors.grey[850],
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Tab indicators
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < browserState.tabs.length; i++)
                        TabIndicator(
                          index: i,
                          isActive: selectedIndex == i,
                          tabCount: browserState.tabs.length,
                          onTap: () => onTabTapped(i),
                          onClose: () {
                            context.read<BrowserCubit>().closeTab(i);
                            // Eğer kapatılan sekme aktif sekme ise veya sonrası ise,
                            // selectedIndex'i güncellemek için callback kullanılabilir
                            if (i <= selectedIndex) {
                              onTabTapped((selectedIndex - 1).clamp(0, browserState.tabs.length - 2));
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              // Add new tab button
              GestureDetector(
                onTap: onAddTab,
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white70,
                    size: 20,
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
