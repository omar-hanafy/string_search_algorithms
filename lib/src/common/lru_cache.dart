import 'dart:collection';

import 'package:string_search_algorithms/src/common/exceptions.dart';

/// A Least Recently Used (LRU) cache implementation.
class LruCache<K, V extends Object> {
  /// Creates a new [LruCache] with the given [capacity].
  LruCache({required this.capacity}) {
    if (capacity <= 0) {
      throw InvalidConfigurationException(
        'LruCache capacity must be > 0',
        {'capacity': capacity},
      );
    }
  }

  /// The maximum number of items the cache can hold.
  final int capacity;

  final LinkedHashMap<K, V> _map = LinkedHashMap<K, V>();

  /// Returns the current number of items in the cache.
  int get length => _map.length;

  /// Retrieves the value associated with [key], or `null` if not found.
  ///
  /// Accessing the value moves it to the most-recently used position.
  V? get(K key) {
    final value = _map.remove(key);
    if (value == null) return null;

    // Re-insert to mark as most-recently used.
    _map[key] = value;
    return value;
  }

  /// Adds or updates [value] for [key].
  ///
  /// If the cache is full, the least-recently used item is evicted.
  void put(K key, V value) {
    // Remove existing to refresh order.
    _map.remove(key);

    // Evict least-recently used if at capacity.
    if (_map.length >= capacity && _map.isNotEmpty) {
      _map.remove(_map.keys.first);
    }

    _map[key] = value;
  }

  /// Checks if [key] exists in the cache without updating its usage.
  bool containsKey(K key) => _map.containsKey(key);

  /// Clears all items from the cache.
  void clear() => _map.clear();

  /// Returns a map of cache statistics (length, capacity, utilization).
  Map<String, Object?> get stats => <String, Object?>{
        'length': _map.length,
        'capacity': capacity,
        'utilization': capacity == 0 ? 0.0 : _map.length / capacity,
      };
}
