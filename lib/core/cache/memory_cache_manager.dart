import 'package:brave_search/core/cache/cache_manager.dart';

class MemoryCacheManager<T> implements CacheManager<T> {
  final Map<String, Map<int, List<T>>> _cache = {};

  @override
  Future<void> init() async {
    // Memory cache için özel bir init gerekmez
  }

  @override
  Future<void> add(String key, int page, List<T> results) async {
    if (!_cache.containsKey(key)) {
      _cache[key] = {};
    }
    _cache[key]![page] = results;
  }

  @override
  Future<List<T>?> get(String key, int page) async {
    if (_cache.containsKey(key) && _cache[key]!.containsKey(page)) {
      return _cache[key]![page];
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }

  @override
  Future<bool> exists(String key, int page) async {
    return _cache.containsKey(key) && _cache[key]!.containsKey(page);
  }
}