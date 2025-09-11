import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import '../cubit/browser_cubit.dart';
import '../cubit/browser_state.dart';

part 'search_bar_widget.dart';
part 'search_actions.dart';

class BrowserHeader extends StatefulWidget {
  const BrowserHeader({super.key});

  @override
  State<BrowserHeader> createState() => _BrowserHeaderState();
}

class _BrowserHeaderState extends State<BrowserHeader> {
  late TextEditingController _searchController;
  late FocusNode _searchFocus;
  String _lastSearchedQuery = '';

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
    
    return BlocListener<BrowserCubit, BrowserState>(
      listener: (context, browserState) {
        // Sekme değiştiğinde ve sorgu varsa arama yap
        if (browserState.tabSwitched) {
          final browserCubit = context.read<BrowserCubit>();
          final currentQuery = browserCubit.activeTabQuery;
          
          if (currentQuery.isNotEmpty) {
            // Önce tüm sonuçları temizle
            _clearAllSearchResults(context);
            
            // Arama yap
            performSearch(context, currentQuery, browserState.searchFilter, forceRefresh: true);
          }
        }
      },
      child: Container(
        color: theme.appBarTheme.backgroundColor,
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<BrowserCubit, BrowserState>(
                builder: (context, browserState) {
                  final browserCubit = context.read<BrowserCubit>();
                  final currentQuery = browserCubit.activeTabQuery;

                  // Kontrolcüyü güncel sorgu ile senkronize et
                  if (_searchController.text != currentQuery) {
                    _searchController.text = currentQuery;
                  }

                  return SearchBarWidget(
                    searchController: _searchController,
                    searchFocus: _searchFocus,
                    onSubmitted: (query) => performSearch(context, query, browserState.searchFilter),
                    onQueryChanged: (query) {
                      if (browserState.tabs.isNotEmpty) {
                        final currentTabId = browserState.tabs[browserState.activeTabIndex];
                        browserCubit.updateTabQuery(currentTabId, query);
                        
                        // Her karakter değişiminde sonuçları temizle
                        _clearSearchResults(context, browserState.searchFilter);
                        
                        // Yazarken eski sonuçları temizle
                        if (query.length < _lastSearchedQuery.length || 
                            !query.contains(_lastSearchedQuery)) {
                          _clearSearchResults(context, browserState.searchFilter);
                        }
                      }
                    },
                    onRefresh: () => performSearch(context, _searchController.text, browserState.searchFilter, forceRefresh: true),
                  );
                },
              ),
            ),
          ],
        ).allPadding(16),
      ),
    );
  }

  void performSearch(BuildContext context, String query, String currentFilter, {bool forceRefresh = false}) {
    if (query.trim().isEmpty) return;

    final browserCubit = context.read<BrowserCubit>();
    final browserState = browserCubit.state;
    
    if (browserState.tabs.isNotEmpty && 
        browserState.activeTabIndex < browserState.tabs.length) {
      final currentTabId = browserState.tabs[browserState.activeTabIndex];
      browserCubit.updateTabQuery(currentTabId, query);
      
      // Arama geçmişine ekle
      browserCubit.addToSearchHistory(
        currentTabId, 
        query, 
        browserCubit.activeTabSearchType
      );
      
      // Son arama sorgusunu kaydet
      _lastSearchedQuery = query;
    }

    // arama yap
    SearchActions.performSearch(
      context: context,
      query: query,
      currentFilter: currentFilter,
      forceRefresh: forceRefresh,
    );

    _searchFocus.unfocus();
  }

  void _clearSearchResults(BuildContext context, String currentFilter) {
    // sonuçları temizle
    SearchActions.clearSearchResults(context, currentFilter);
  }

  void _clearAllSearchResults(BuildContext context) {
    // tüm sonuçları temizle
    context.read<WebSearchCubit>().clearResults();
    context.read<ImageSearchCubit>().clearResults();
    context.read<VideoSearchCubit>().clearResults();
    context.read<NewsSearchCubit>().clearResults();
  }
}