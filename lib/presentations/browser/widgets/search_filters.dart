import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../web/cubit/web_search_cubit.dart';
import '../../images/cubit/image_search_cubit.dart';
import '../../videos/cubit/video_search_cubit.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, state) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(
                label: 'Tümü',
                isSelected: state.searchFilter == 'all',
                onTap: () => _onFilterChanged(context, 'all', state),
              ),
              _FilterChip(
                label: 'Görseller',
                isSelected: state.searchFilter == 'images',
                onTap: () => _onFilterChanged(context, 'images', state),
              ),
              _FilterChip(
                label: 'Videolar',
                isSelected: state.searchFilter == 'videos',
                onTap: () => _onFilterChanged(context, 'videos', state),
              ),
              _FilterChip(
                label: 'Haberler',
                isSelected: state.searchFilter == 'news',
                onTap: () => _onFilterChanged(context, 'news', state),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onFilterChanged(BuildContext context, String newFilter, BrowserState browserState) {
    context.read<BrowserCubit>().setSearchFilter(newFilter);
    
    final browserCubit = context.read<BrowserCubit>();
    final currentQuery = browserCubit.activeTabQuery;
    
    if (currentQuery.isNotEmpty) {
      switch (newFilter) {
        case 'all':
        case 'web':
          context.read<WebSearchCubit>().searchWeb(currentQuery);
          break;
        case 'images':
          context.read<ImageSearchCubit>().searchImages(currentQuery);
          break;
        case 'videos':
          context.read<VideoSearchCubit>().searchVideos(currentQuery);
          break;
        case 'news':
          context.read<NewsSearchCubit>().searchNews(currentQuery); // Yeni eklenen satır
          break;
      }
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
         alignment: Alignment.center,
         padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? theme.primaryColor : theme.dividerColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}