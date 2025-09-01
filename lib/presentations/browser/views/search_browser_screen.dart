import 'package:brave_search/common/widgets/tab_navigation_bar.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/browser_cubit.dart';
import '../cubit/browser_state.dart';
import '../widgets/browser_header.dart';
import '../widgets/empty_browser_state.dart';
import '../widgets/search_results_view.dart';
import '../../web/cubit/web_search_cubit.dart';
import '../../images/cubit/image_search_cubit.dart';

class SearchBrowserScreen extends StatefulWidget {
  const SearchBrowserScreen({super.key});

  @override
  State<SearchBrowserScreen> createState() => _SearchBrowserScreenState();
}

class _SearchBrowserScreenState extends State<SearchBrowserScreen> {
  late BrowserCubit _browserCubit;
  late WebSearchCubit _webSearchCubit;
  late ImageSearchCubit _imageSearchCubit;
  late VideoSearchCubit _videoSearchCubit;
  late NewsSearchCubit _newsSearchCubit;

  @override
  void initState() {
    super.initState();
    
    // GetIt'ten instance'ları al
    _browserCubit = GetIt.instance<BrowserCubit>();
    _webSearchCubit = GetIt.instance<WebSearchCubit>();
    _imageSearchCubit = GetIt.instance<ImageSearchCubit>();
    _videoSearchCubit = GetIt.instance<VideoSearchCubit>();
     _newsSearchCubit = GetIt.instance<NewsSearchCubit>();
    
    // İlk sekmeyi oluştur
    if (_browserCubit.state.tabs.isEmpty) {
      _browserCubit.addTab();
    }
  }

  void _onTabTapped(int index) {
    _browserCubit.switchTab(index);
  }

  void _addNewTab() {
    _browserCubit.addTab();
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
          child: Column(
            children: [
           
              // Browser Header with search bar
              const BrowserHeader(),
              Expanded(
                child: BlocBuilder<BrowserCubit, BrowserState>(
                  builder: (context, browserState) {
                    
                    if (browserState.tabs.isEmpty) {
                      return const EmptyBrowserState();
                    }
                    return const SearchResultsView();
                  },
                ),
              ),
            ],
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

  @override
  void dispose() {
    // GetIt instance'ları dispose etme - singleton'lar
    super.dispose();
  }
}