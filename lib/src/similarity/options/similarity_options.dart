import 'package:string_search_algorithms/src/similarity/options/algorithm_options.dart';
import 'package:string_search_algorithms/src/similarity/options/cache_options.dart';
import 'package:string_search_algorithms/src/similarity/options/normalization_options.dart';

/// Comprehensive configuration for the [StringSimilarityEngine].
class SimilarityOptions {
  /// Creates a [SimilarityOptions].
  const SimilarityOptions({
    this.normalization = const NormalizationOptions(),
    this.cache = const CacheOptions(),
    this.algorithms = const AlgorithmOptions(),
  });

  /// Options for input normalization.
  final NormalizationOptions normalization;

  /// Options for internal caching.
  final CacheOptions cache;

  /// Options specific to certain algorithms.
  final AlgorithmOptions algorithms;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  SimilarityOptions copyWith({
    NormalizationOptions? normalization,
    CacheOptions? cache,
    AlgorithmOptions? algorithms,
  }) {
    return SimilarityOptions(
      normalization: normalization ?? this.normalization,
      cache: cache ?? this.cache,
      algorithms: algorithms ?? this.algorithms,
    );
  }
}
