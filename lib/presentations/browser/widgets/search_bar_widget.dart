part of 'browser_header.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final Function(String) onSubmitted;
  final Function(String) onQueryChanged;
  final VoidCallback onRefresh;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.searchFocus,
    required this.onSubmitted,
    required this.onQueryChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

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
              controller: searchController,
              focusNode: searchFocus,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: AppConstant.hintText,
                hintStyle: TextStyle(color: colors.textHint),
                border: InputBorder.none,
              ),
              onSubmitted: onSubmitted,
              onChanged: onQueryChanged,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh, 
              color: colors.iconSecondary, 
              size: 20,
            ),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}