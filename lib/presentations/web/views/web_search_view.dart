/*
// presentation/views/web/web_search_view.dart

import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_state.dart';
import 'package:brave_search/presentations/web/widgets/web_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class WebSearchView extends StatelessWidget {
  final String query;
  
  const WebSearchView({super.key, required this.query});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebSearchCubit(
        context.read<BraveRepository>(),
      )..search(query),
      child: BlocBuilder<WebSearchCubit, WebSearchState>(
        builder: (context, state) {
          return _buildContent(context, state);
        },
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, WebSearchState state) {
    if (state is WebSearchInitial) {
      return const Center(child: Text('Arama yapın...'));
    } else if (state is WebSearchLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WebSearchError) {
      return Center(child: Text('Hata: ${state.message}'));
    } else if (state is WebSearchSuccess) {
      return _buildResultsList(context, state.results, state.hasMore);
    } else if (state is WebSearchLoadingMore) {
      return _buildResultsList(context, state.results, true);
    } else {
      return const Center(child: Text('Beklenmeyen durum'));
    }
  }
  
  Widget _buildResultsList(
    BuildContext context, 
    List<WebResultItem>? results, 
    bool hasMore
  ) {
    if (results == null || results.isEmpty) {
      return const Center(child: Text('Sonuç bulunamadı'));
    }
    
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            hasMore) {
          context.read<WebSearchCubit>().loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: results.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == results.length) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final result = results[index];
          return WebResultItem(result: result);
        },
      ),
    );
  }
}
*/