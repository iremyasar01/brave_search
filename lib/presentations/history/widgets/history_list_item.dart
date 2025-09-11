import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/domain/entities/search_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';

class HistoryListItem extends StatelessWidget {
  final SearchHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryListItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          item.searchType == WebSearchStrings.web
              ? Icons.public
              : Icons.article,
          color: colors.iconSecondary,
        ),
        title: Text(
          item.query,
          style: theme.textTheme.bodyLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDateTime(item.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textHint,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: colors.iconSecondary,
            size: 20,
          ),
          onPressed: onDelete,
        ),
        onTap: () {
          // Önce tüm modalleri kapat
          Navigator.of(context).popUntil((route) => route.isFirst);
          
          final browserCubit = context.read<BrowserCubit>();
          final currentTabId = browserCubit.activeTabId;
          
          if (currentTabId != null) {
            // Önce tüm sonuçları temizle
            _clearAllSearchResults(context);
            
            // Sekme sorgusunu güncelle
            browserCubit.updateTabQuery(currentTabId, item.query);
            
            // Arama türünü güncelle
            browserCubit.setSearchType(currentTabId, item.searchType);
            
            // Arama filtresini güncelle
            browserCubit.setSearchFilter(item.searchType);
            
            // Arama geçmişine ekle
            browserCubit.addToSearchHistory(currentTabId, item.query, item.searchType);
            
            // Arama yap
            _performSearch(context, item.query, item.searchType);
          }
        },
      ),
    );
  }

  void _performSearch(BuildContext context, String query, String searchType) {
    switch (searchType) {
      case 'web':
        context.read<WebSearchCubit>().searchWeb(query, forceRefresh: true);
        break;
      case 'images':
        context.read<ImageSearchCubit>().searchImages(query, forceRefresh: true);
        break;
      case 'videos':
        context.read<VideoSearchCubit>().searchVideo(query, forceRefresh: true);
        break;
      case 'news':
        context.read<NewsSearchCubit>().searchNews(query, forceRefresh: true);
        break;
    }
  }

  void _clearAllSearchResults(BuildContext context) {
    context.read<WebSearchCubit>().clearResults();
    context.read<ImageSearchCubit>().clearResults();
    context.read<VideoSearchCubit>().clearResults();
    context.read<NewsSearchCubit>().clearResults();
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String timeStr =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (itemDate == today) {
      return 'Bugün $timeStr';
    } else if (itemDate == yesterday) {
      return 'Dün $timeStr';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} $timeStr';
    }
  }
}