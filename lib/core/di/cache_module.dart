import 'package:brave_search/core/cache/cache_manager.dart';
import 'package:brave_search/core/cache/memory_cache_manager.dart';
import 'package:brave_search/domain/entities/web_search_result.dart';
import 'package:brave_search/domain/entities/news_search_result.dart';
import 'package:brave_search/domain/entities/image_search_result.dart';
import 'package:brave_search/domain/entities/video_search_result.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CacheModule {
  @lazySingleton
  @Named('webCacheManager')
  CacheManager<WebSearchResult> get webCacheManager => 
      MemoryCacheManager<WebSearchResult>();

  @lazySingleton
  @Named('newsCacheManager')
  CacheManager<NewsSearchResult> get newsCacheManager => 
      MemoryCacheManager<NewsSearchResult>();

  @lazySingleton
  @Named('imageCacheManager')
  CacheManager<ImageSearchResult> get imageCacheManager => 
      MemoryCacheManager<ImageSearchResult>();

  @lazySingleton
  @Named('videoCacheManager')
  CacheManager<VideoSearchResult> get videoCacheManager => 
      MemoryCacheManager<VideoSearchResult>();
}