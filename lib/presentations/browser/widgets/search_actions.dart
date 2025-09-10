part of 'browser_header.dart';

class SearchActions {
  static void performSearch({
    required BuildContext context,
    required String query,
    required String currentFilter,
    bool forceRefresh = false,
  }) {
    if (query.trim().isEmpty) return;

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
  }

  static void clearSearchResults(BuildContext context, String currentFilter) {
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