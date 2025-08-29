import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/empty_browser_state.dart';
import 'package:brave_search/presentations/browser/widgets/search_filters.dart';
import 'package:brave_search/presentations/browser/widgets/search_results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/browser_header.dart';


class SearchBrowserScreen extends StatelessWidget {
  const SearchBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}