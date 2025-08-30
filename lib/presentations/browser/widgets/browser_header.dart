import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'tab_widget.dart';

class BrowserHeader extends StatefulWidget {
  const BrowserHeader({super.key});

  @override
  State<BrowserHeader> createState() => _BrowserHeaderState();
}

class _BrowserHeaderState extends State<BrowserHeader> {
  late TextEditingController _searchController;
  late FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[800],
      child: Column(
        children: [
          // Tab bar
          BlocBuilder<BrowserCubit, BrowserState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...state.tabs.asMap().entries.map((entry) {
                            final index = entry.key;
                            final tabId = entry.value;
                            final isActive = index == state.activeTabIndex;
                            final query = state.tabQueries[tabId] ?? 'Yeni Sekme';
                            
                            return TabWidget(
                              title: query.isEmpty ? 'Yeni Sekme' : query,
                              isActive: isActive,
                              onTap: () => context.read<BrowserCubit>().switchTab(index),
                              onClose: () => context.read<BrowserCubit>().closeTab(index),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => context.read<BrowserCubit>().addTab(),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          // Address/Search bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.search, color: Colors.white54, size: 20),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Ara veya adres gir...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (query) => _performSearch(context, query),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white54, size: 20),
                  onPressed: () => _performSearch(context, _searchController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(BuildContext context, String query) {
    if (query.trim().isEmpty) return;

    final browserCubit = context.read<BrowserCubit>();
    final searchCubit = context.read<WebSearchCubit>();
    final browserState = browserCubit.state;
    
    // Update current tab query
    if (browserState.tabs.isNotEmpty) {
      final currentTabId = browserState.tabs[browserState.activeTabIndex];
      browserCubit.updateTabQuery(currentTabId, query);
    }
    
    // Perform search based on current filter
   // searchCubit.search(query, searchType: _getSearchTypeFromFilter(browserState.searchFilter));
     searchCubit.searchWeb(query);
    
    // Update search controller
    _searchController.text = query;
  }

  String _getSearchTypeFromFilter(String filter) {
    switch (filter) {
      case 'images': return 'images';
      case 'videos': return 'videos';
      case 'news': return 'news';
      default: return 'web';
    }
  }
}