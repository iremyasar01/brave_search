import 'package:brave_search/core/cache/cache_manager.dart';
import 'package:hive/hive.dart';

class HiveCacheManager<T> implements CacheManager<T> {
  late Box<Map<int, List<dynamic>>> _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<Map<int, List<dynamic>>>('search_cache');
  }

  @override
  Future<void> add(String key, int page, List<T> results) async {
    final existingData = _box.get(key) ?? {};
    existingData[page] = results;
    await _box.put(key, existingData);
  }

  @override
  Future<List<T>?> get(String key, int page) async {
    final data = _box.get(key);
    if (data != null && data.containsKey(page)) {
      return data[page] as List<T>?;
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<bool> exists(String key, int page) async {
    final data = _box.get(key);
    return data != null && data.containsKey(page);
  }
}