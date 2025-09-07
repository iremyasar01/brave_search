abstract class CacheManager<T> {
  Future<void> init();
  Future<void> add(String key, int page, List<T> results);
  Future<List<T>?> get(String key, int page);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> exists(String key, int page);
}