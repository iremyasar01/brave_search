import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SearchFilters extends StatelessWidget {
  const SearchFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserCubit, BrowserState>(
      builder: (context, state) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _FilterChip(
                label: 'Tümü',
                isSelected: state.searchFilter == 'all',
                onTap: () => context.read<BrowserCubit>().setSearchFilter('all'),
              ),
              _FilterChip(
                label: 'Görseller',
                isSelected: state.searchFilter == 'images',
                onTap: () => context.read<BrowserCubit>().setSearchFilter('images'),
              ),
              _FilterChip(
                label: 'Videolar',
                isSelected: state.searchFilter == 'videos',
                onTap: () => context.read<BrowserCubit>().setSearchFilter('videos'),
              ),
              _FilterChip(
                label: 'Haberler',
                isSelected: state.searchFilter == 'news',
                onTap: () => context.read<BrowserCubit>().setSearchFilter('news'),
              ),
            ],
          ),
        );
      },
    );
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
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.white54,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}