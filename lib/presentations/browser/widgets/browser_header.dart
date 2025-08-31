import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/theme_cubit.dart';
import '../cubit/browser_cubit.dart';
import '../cubit/browser_state.dart';
import '../../web/cubit/web_search_cubit.dart';

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
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: theme.appBarTheme.backgroundColor,
      child: Row(
        children: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark 
                ? Icons.light_mode 
                : Icons.dark_mode,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            tooltip: theme.brightness == Brightness.dark 
              ? 'Açık Tema' 
              : 'Koyu Tema',
          ),
          
          const SizedBox(width: 8),
          
          // Search bar
          Expanded(
            child: BlocBuilder<BrowserCubit, BrowserState>(
              builder: (context, browserState) {
                String currentQuery = '';
                if (browserState.tabs.isNotEmpty && 
                    browserState.activeTabIndex < browserState.tabs.length) {
                  final currentTabId = browserState.tabs[browserState.activeTabIndex];
                  currentQuery = browserState.tabQueries[currentTabId] ?? '';
                }

                if (_searchController.text != currentQuery) {
                  _searchController.text = currentQuery;
                }

                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.searchBarBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search, 
                          color: colors.iconSecondary, 
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'Ara veya adres gir...',
                            hintStyle: TextStyle(color: colors.textHint),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (query) => _performSearch(context, query, browserState.searchFilter),
                          onChanged: (query) {
                            if (browserState.tabs.isNotEmpty) {
                              final currentTabId = browserState.tabs[browserState.activeTabIndex];
                              context.read<BrowserCubit>().updateTabQuery(currentTabId, query);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh, 
                          color: colors.iconSecondary, 
                          size: 20,
                        ),
                        onPressed: () => _performSearch(context, _searchController.text, browserState.searchFilter),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(BuildContext context, String query, String currentFilter) {
    if (query.trim().isEmpty) return;

    final browserCubit = context.read<BrowserCubit>();
    final browserState = browserCubit.state;
    
    if (browserState.tabs.isNotEmpty && 
        browserState.activeTabIndex < browserState.tabs.length) {
      final currentTabId = browserState.tabs[browserState.activeTabIndex];
      browserCubit.updateTabQuery(currentTabId, query);
      browserCubit.markTabAsSearched(currentTabId);
    }
    
    switch (currentFilter) {
      case 'all':
      case 'web':
        context.read<WebSearchCubit>().searchWeb(query);
        break;
      case 'images':
        context.read<ImageSearchCubit>().searchImages(query);
        break;
      case 'videos':
        context.read<VideoSearchCubit>().searchVideos(query);
        break;
      case 'news':
        context.read<NewsSearchCubit>().searchNews(query);
        break;
      default:
        context.read<WebSearchCubit>().searchWeb(query);
    }

    _searchFocus.unfocus();
  }
}