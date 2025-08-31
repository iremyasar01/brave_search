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
    // ✅ Theme'den renkleri al
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, browserState) {
        return Container(
          // ✅ Theme extension'dan al
          color: colors.bottomNavBackground,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Tab sayısı göstergesi
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colors.bottomNavBorder,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${browserState.tabs.length}',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: colors.iconSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Ana sayfa butonu
              IconButton(
                onPressed: () {
                  // Ana sayfaya gitme işlevi
                },
                icon: Icon(
                  Icons.home_outlined,
                  color: colors.iconSecondary,
                  size: 24,
                ),
              ),
              
              // Yeni sekme ekleme butonu
              IconButton(
                onPressed: onAddTab,
                icon: Icon(
                  Icons.add,
                  color: colors.iconSecondary,
                  size: 24,
                ),
              ),
              
              // Menü butonu
              IconButton(
                onPressed: () {
                  _showTabsOverview(context, browserState);
                },
                icon: Icon(
                  Icons.more_vert,
                  color: colors.iconSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTabsOverview(BuildContext context, BrowserState initialBrowserState) {
    // Ana context'i sakla
    final parentContext = context;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    showModalBottomSheet(
      context: context,
      // ✅ Theme extension'dan renk al
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      builder: (modalContext) => BlocBuilder<BrowserCubit, BrowserState>(
        bloc: parentContext.read<BrowserCubit>(),
        builder: (builderContext, currentBrowserState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentBrowserState.tabs.length} Gizli Sekme',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(modalContext),
                      icon: Icon(
                        Icons.close, 
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tabs grid - Empty state kontrolü
                currentBrowserState.tabs.isEmpty 
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'Hiç sekme yok',
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
                        itemCount: currentBrowserState.tabs.length,
                        itemBuilder: (gridContext, index) {
                          // Index kontrolü
                          if (index >= currentBrowserState.tabs.length) {
                            return Container(); // Boş container döndür
                          }
                          
                          final tabId = currentBrowserState.tabs[index];
                          final query = currentBrowserState.tabQueries[tabId] ?? 'Ana Sayfa';
                          final isActive = index == currentBrowserState.activeTabIndex;
                          
                          return GestureDetector(
                            onTap: () {
                              onTabTapped(index);
                              Navigator.pop(modalContext);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // ✅ Theme extension'dan renk al
                                color: colors.tabBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: isActive 
                                  ? Border.all(color: theme.primaryColor, width: 2)
                                  : null,
                              ),
                              child: Column(
                                children: [
                                  // Tab header
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.public,
                                          color: colors.accent, // ✅ Theme'den accent rengi
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            query.isEmpty ? 'Ana Sayfa' : query,
                                            style: TextStyle(
                                              color: theme.textTheme.bodyLarge?.color,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (currentBrowserState.tabs.length > 1)
                                          GestureDetector(
                                            onTap: () {
                                              // Index tekrar kontrol et
                                              if (index < currentBrowserState.tabs.length) {
                                                parentContext.read<BrowserCubit>().closeTab(index);
                                                // Son sekme kapanıyorsa modal'ı kapat
                                                if (currentBrowserState.tabs.length == 1) {
                                                  Navigator.pop(modalContext);
                                                }
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                color: colors.iconSecondary,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Tab content preview
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        // ✅ Theme extension'dan renk al
                                        color: colors.tabActiveBackground,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.public,
                                          color: colors.accent,
                                          size: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                
                // Add new tab button
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    onAddTab();
                    Navigator.pop(modalContext);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Sekme'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor, // ✅ Theme'den primary renk
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
      ),
    );
  }
}