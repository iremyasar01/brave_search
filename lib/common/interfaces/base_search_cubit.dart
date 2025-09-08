import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/cache/cache_manager.dart';

abstract class BaseSearchCubit<T, S> extends Cubit<S> {
  final CacheManager<T> cacheManager;
  
  BaseSearchCubit(this.cacheManager, S initialState) : super(initialState);
  
  // Ortak cache işlemleri
  Future<bool> checkAndEmitFromCache(String query, int page) async {
    if (await cacheManager.exists(query, page)) {
      final cachedResults = await cacheManager.get(query, page);
      if (cachedResults != null) {
        emitCachedResults(query, page, cachedResults);
        return true;
      }
    }
    return false;
  }
  
  Future<void> addToCache(String query, int page, List<T> results) async {
    await cacheManager.add(query, page, results);
  }
  
  Future<void> clearCache() async {
    await cacheManager.clear();
  }
  
  // Her cubit kendi emit metodunu implemente etmeli
  void emitCachedResults(String query, int page, List<T> results);
}