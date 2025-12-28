/// Configuration options for internal caching.
class CacheOptions {
  /// Creates a [CacheOptions].
  const CacheOptions({
    this.enabled = true,
    this.normalizedCapacity = 1000,
    this.bigramCapacity = 1000,
    this.ngramCapacity = 1000,
  });

  /// Whether caching is enabled (default: true).
  final bool enabled;

  /// Capacity for the normalized string cache.
  final int normalizedCapacity;

  /// Capacity for the bigram cache.
  final int bigramCapacity;

  /// Capacity for the n-gram cache.
  final int ngramCapacity;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  CacheOptions copyWith({
    bool? enabled,
    int? normalizedCapacity,
    int? bigramCapacity,
    int? ngramCapacity,
  }) {
    return CacheOptions(
      enabled: enabled ?? this.enabled,
      normalizedCapacity: normalizedCapacity ?? this.normalizedCapacity,
      bigramCapacity: bigramCapacity ?? this.bigramCapacity,
      ngramCapacity: ngramCapacity ?? this.ngramCapacity,
    );
  }
}
