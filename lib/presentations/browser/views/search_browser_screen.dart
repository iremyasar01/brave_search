import 'package:brave_search/common/widgets/bottomnavbar/tab_navigation_bar.dart';
import 'package:brave_search/core/mixins/scroll_visibility_mixin.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/core/network/views/no_internet_screen.dart';
import 'package:brave_search/core/network/widgets/network_status_banner.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/browser_header.dart';
import 'package:brave_search/presentations/browser/widgets/empty_browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/search_results_view.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SearchBrowserScreen extends StatefulWidget {
  const SearchBrowserScreen({super.key});

  @override
  State<SearchBrowserScreen> createState() => _SearchBrowserScreenState();
}

class _SearchBrowserScreenState extends State<SearchBrowserScreen> 
    with ScrollVisibilityMixin {
  late BrowserCubit _browserCubit;
  late WebSearchCubit _webSearchCubit;
  late ImageSearchCubit _imageSearchCubit;
  late VideoSearchCubit _videoSearchCubit;
  late NewsSearchCubit _newsSearchCubit;
  late ScrollController _scrollController;
  bool _isEmptyState = false;

  @override
  void initState() {
    super.initState();
    
    _browserCubit = GetIt.instance<BrowserCubit>();
    _webSearchCubit = GetIt.instance<WebSearchCubit>();
    _imageSearchCubit = GetIt.instance<ImageSearchCubit>();
    _videoSearchCubit = GetIt.instance<VideoSearchCubit>();
    _newsSearchCubit = GetIt.instance<NewsSearchCubit>();
    
    // Scroll controller'ı başlat
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    disposeVisibilityNotifiers();
    super.dispose();
  }

  // Scroll listener
  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    // Empty state durumunu da parametre olarak geç
    updateVisibilityBasedOnScroll(scrollPosition, maxScroll, isEmptyState: _isEmptyState);
  }

  void _onTabTapped(int index) {
    _browserCubit.switchTab(index);
  }
  
  void _addNewTab() => _browserCubit.addTab();

  void _handleTabSwitchSearch(BrowserState browserState) {
    if (!browserState.shouldRefreshSearch) return;
    
    final currentQuery = _browserCubit.activeTabQuery;
    if (currentQuery.isEmpty) return;

    if (browserState.shouldClearCache) {
      _clearAllSearchResults();
    }

    switch (browserState.searchFilter) {
      case 'all':
      case 'web':
        _webSearchCubit.searchWeb(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
      case 'images':
        _imageSearchCubit.searchImages(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
      case 'videos':
        _videoSearchCubit.searchVideo(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
      case 'news':
        _newsSearchCubit.searchNews(currentQuery, forceRefresh: browserState.shouldClearCache);
        break;
    }

    _browserCubit.resetSearchRefreshFlag();
  }

  void _clearAllSearchResults() {
    _webSearchCubit.clearResults();
    _imageSearchCubit.clearResults();
    _videoSearchCubit.clearResults();
    _newsSearchCubit.clearResults();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _browserCubit),
        BlocProvider.value(value: _webSearchCubit),
        BlocProvider.value(value: _imageSearchCubit),
        BlocProvider.value(value: _videoSearchCubit),
        BlocProvider.value(value: _newsSearchCubit),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<NetworkCubit, NetworkState>(
            builder: (context, networkState) {
              if (networkState is NetworkDisconnected) {
                return const NoInternetScreen();
              }
              
              return BlocConsumer<BrowserCubit, BrowserState>(
                listener: (context, browserState) {
                  _handleTabSwitchSearch(browserState);
                  
                  // Browser state değiştiğinde empty state durumunu güncelle
                  final newEmptyState = browserState.tabs.isEmpty || 
                      (browserState.tabs.isNotEmpty && _browserCubit.activeTabQuery.isEmpty);
                  
                  if (_isEmptyState != newEmptyState) {
                    setState(() {
                      _isEmptyState = newEmptyState;
                    });
                    
                    // Empty state durumunda header'ı her zaman göster
                    if (_isEmptyState) {
                      updateHeaderVisibility(true);
                      updatePaginationVisibility(false);
                    }
                  }
                },
                builder: (context, browserState) {
                  // Empty state durumunu daha doğru belirle
                  final currentEmptyState = browserState.tabs.isEmpty || 
                      (browserState.tabs.isNotEmpty && _browserCubit.activeTabQuery.isEmpty);
                  
                  if (_isEmptyState != currentEmptyState) {
                    _isEmptyState = currentEmptyState;
                    
                    // Empty state'te header'ı her zaman göster
                    if (_isEmptyState) {
                      updateHeaderVisibility(true);
                      updatePaginationVisibility(false);
                    }
                  }
                  
                  return Column(
                    children: [
                      const NetworkStatusBanner(),
                      // Header'ı ValueListenableBuilder ile sarmalayın
                      ValueListenableBuilder<bool>(
                        valueListenable: headerVisibilityNotifier,
                        builder: (context, isHeaderVisible, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: isHeaderVisible ? null : 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isHeaderVisible ? 1.0 : 0.0,
                              child: isHeaderVisible ? const BrowserHeader() : const SizedBox.shrink(),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: _isEmptyState
                            ? const EmptyBrowserState()
                            : SearchResultsView(
                                scrollController: _scrollController,
                                headerVisibilityNotifier: headerVisibilityNotifier,
                                paginationVisibilityNotifier: paginationVisibilityNotifier,
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<BrowserCubit, BrowserState>(
          builder: (context, browserState) {
            return TabNavigationBar(
              selectedIndex: browserState.activeTabIndex,
              onTabTapped: _onTabTapped,
              onAddTab: _addNewTab,
            );
          },
        ),
      ),
    );
  }
}