class CacheOptions {
  const CacheOptions({
    this.enabled = true,
    this.normalizedCapacity = 1000,
    this.bigramCapacity = 1000,
    this.ngramCapacity = 1000,
  });

  final bool enabled;
  final int normalizedCapacity;
  final int bigramCapacity;
  final int ngramCapacity;

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
