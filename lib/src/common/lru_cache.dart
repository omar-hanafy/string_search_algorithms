import 'dart:collection';

import 'exceptions.dart';

class LruCache<K, V extends Object> {
  LruCache({required this.capacity}) {
    if (capacity <= 0) {
      throw InvalidConfigurationException(
        'LruCache capacity must be > 0',
        {'capacity': capacity},
      );
    }
  }

  final int capacity;

  final LinkedHashMap<K, V> _map = LinkedHashMap<K, V>();

  int get length => _map.length;

  V? get(K key) {
    final value = _map.remove(key);
    if (value == null) return null;
    
    // Re-insert to mark as most-recently used.
    _map[key] = value;
    return value;
  }

  void put(K key, V value) {
    // Remove existing to refresh order.
    _map.remove(key);

    // Evict least-recently used if at capacity.
    if (_map.length >= capacity && _map.isNotEmpty) {
      _map.remove(_map.keys.first);
    }

    _map[key] = value;
  }

  bool containsKey(K key) => _map.containsKey(key);

  void clear() => _map.clear();

  Map<String, Object?> get stats => <String, Object?>{
        'length': _map.length,
        'capacity': capacity,
        'utilization': capacity == 0 ? 0.0 : _map.length / capacity,
      };
}
