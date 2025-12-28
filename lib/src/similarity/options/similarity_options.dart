import 'algorithm_options.dart';
import 'cache_options.dart';
import 'normalization_options.dart';

class SimilarityOptions {
  const SimilarityOptions({
    this.normalization = const NormalizationOptions(),
    this.cache = const CacheOptions(),
    this.algorithms = const AlgorithmOptions(),
  });

  final NormalizationOptions normalization;
  final CacheOptions cache;
  final AlgorithmOptions algorithms;

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
