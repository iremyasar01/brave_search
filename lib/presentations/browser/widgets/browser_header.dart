import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
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
    final colors = theme.extension<AppColorsExtension>()!;
    
    return Container(
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

                return Container(
                  height: 50,
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
                            hintText: AppConstant.hintText,
                            hintStyle: TextStyle(color: colors.textHint),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (query) => _performSearch(context, query, browserState.searchFilter),
                          onChanged: (query) {
                            if (browserState.tabs.isNotEmpty) {
                              final currentTabId = browserState.tabs[browserState.activeTabIndex];
                              context.read<BrowserCubit>().updateTabQuery(currentTabId, query);
                              
                              // Yazarken eski sonuçları temizle
                              if (query.length < _lastSearchedQuery.length || 
                                  !query.contains(_lastSearchedQuery)) {
                                _clearSearchResults(context, browserState.searchFilter);
                              }
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
                        onPressed: () => _performSearch(context, _searchController.text, browserState.searchFilter, forceRefresh: true),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ).allPadding(16),
    );
  }

  void _performSearch(BuildContext context, String query, String currentFilter, {bool forceRefresh = false}) {
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

    // Filtre türüne göre ilgili cubit'i tetikle
    switch (currentFilter) {
      case 'all':
      case 'web':
        context.read<WebSearchCubit>().searchWeb(query, forceRefresh: forceRefresh);
        break;
      case 'images':
        context.read<ImageSearchCubit>().searchImages(query, forceRefresh: forceRefresh);
        break;
      case 'videos':
        context.read<VideoSearchCubit>().searchVideo(query, forceRefresh: forceRefresh);
        break;
      case 'news':
        context.read<NewsSearchCubit>().searchNews(query, forceRefresh: forceRefresh);
        break;
      default:
        context.read<WebSearchCubit>().searchWeb(query, forceRefresh: forceRefresh);
    }

    _searchFocus.unfocus();
  }

  void _clearSearchResults(BuildContext context, String currentFilter) {
    // Filtre türüne göre ilgili cubit'in sonuçlarını temizle
    switch (currentFilter) {
      case 'all':
      case 'web':
        context.read<WebSearchCubit>().clearResults();
        break;
      case 'images':
        context.read<ImageSearchCubit>().clearResults();
        break;
      case 'videos':
        context.read<VideoSearchCubit>().clearResults();
        break;
      case 'news':
        context.read<NewsSearchCubit>().clearResults();
        break;
      default:
        context.read<WebSearchCubit>().clearResults();
    }
  }
}