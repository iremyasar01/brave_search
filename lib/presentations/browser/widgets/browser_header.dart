import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/browser_cubit.dart';
import '../cubit/browser_state.dart';
import '../../web/cubit/web_search_cubit.dart';
// import '../../videos/cubit/video_search_cubit.dart';  // Video arama cubit'i
// import '../../news/cubit/news_search_cubit.dart';     // Haber arama cubit'i

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
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[800],
      child: BlocBuilder<BrowserCubit, BrowserState>(
        builder: (context, browserState) {
          // Aktif sekmenin sorgusunu göster
          String currentQuery = '';
          if (browserState.tabs.isNotEmpty && 
              browserState.activeTabIndex < browserState.tabs.length) {
            final currentTabId = browserState.tabs[browserState.activeTabIndex];
            currentQuery = browserState.tabQueries[currentTabId] ?? '';
          }

          // Controller'ı güncelle (sadece farklıysa)
          if (_searchController.text != currentQuery) {
            _searchController.text = currentQuery;
          }

          return Container(
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
                    onSubmitted: (query) => _performSearch(context, query, browserState.searchFilter),
                    onChanged: (query) {
                      // Real-time update için
                      if (browserState.tabs.isNotEmpty) {
                        final currentTabId = browserState.tabs[browserState.activeTabIndex];
                        context.read<BrowserCubit>().updateTabQuery(currentTabId, query);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white54, size: 20),
                  onPressed: () => _performSearch(context, _searchController.text, browserState.searchFilter),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _performSearch(BuildContext context, String query, String currentFilter) {
    if (query.trim().isEmpty) return;

    final browserCubit = context.read<BrowserCubit>();
    final browserState = browserCubit.state;
    
    // Aktif sekmenin sorgusunu güncelle
    if (browserState.tabs.isNotEmpty && 
        browserState.activeTabIndex < browserState.tabs.length) {
      final currentTabId = browserState.tabs[browserState.activeTabIndex];
      browserCubit.updateTabQuery(currentTabId, query);
      // Arama yapıldığını işaretle
      browserCubit.markTabAsSearched(currentTabId);
    }
    
    // Seçili filtreye göre ilgili API'yi çağır
    switch (currentFilter) {
      case 'all':
      case 'web':
        context.read<WebSearchCubit>().searchWeb(query);
        break;
      case 'images':
        context.read<ImageSearchCubit>().searchImages(query);
        break;
      case 'videos':
        // context.read<VideoSearchCubit>().searchVideos(query);
        // Şimdilik web arama kullan
        context.read<WebSearchCubit>().searchWeb(query);
        break;
      case 'news':
        // context.read<NewsSearchCubit>().searchNews(query);
        // Şimdilik web arama kullan
        context.read<WebSearchCubit>().searchWeb(query);
        break;
      default:
        context.read<WebSearchCubit>().searchWeb(query);
    }

    // Focus'u kaldır
    _searchFocus.unfocus();
  }
}