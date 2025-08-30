import 'package:brave_search/common/widgets/tab_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/browser_cubit.dart';
import '../cubit/browser_state.dart';
import '../widgets/browser_header.dart';
import '../widgets/empty_browser_state.dart';
import '../widgets/search_filters.dart';
import '../widgets/search_results_view.dart';
import '../../web/cubit/web_search_cubit.dart';
import '../../images/cubit/image_search_cubit.dart';

class SearchBrowserScreen extends StatefulWidget {
  const SearchBrowserScreen({super.key});

  @override
  State<SearchBrowserScreen> createState() => _SearchBrowserScreenState();
}

class _SearchBrowserScreenState extends State<SearchBrowserScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    final browserCubit = context.read<BrowserCubit>();
    if (index < browserCubit.state.tabs.length) {
      browserCubit.switchTab(index);
    }
  }

  void _addNewTab() {
    final browserCubit = context.read<BrowserCubit>();
    browserCubit.addTab();
    setState(() {
      _selectedIndex = browserCubit.state.tabs.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<BrowserCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<WebSearchCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<ImageSearchCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: Column(
            children: [
              // Browser Header with tabs and address bar
              const BrowserHeader(),
              // Search filters (Tümü, Görseller, Videolar, etc.)
              const SearchFilters(),
              // Main content area
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
        bottomNavigationBar: TabNavigationBar(
          selectedIndex: _selectedIndex,
          onTabTapped: _onTabTapped,
          onAddTab: _addNewTab,
        ),
      ),
    );
  }
}