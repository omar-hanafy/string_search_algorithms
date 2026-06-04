// lib/src/similarity/metrics/registry.dart
import 'package:string_search_algorithms/src/common/exceptions.dart';
import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';

// Built-in metrics
import 'package:string_search_algorithms/src/similarity/metrics/composite.dart';
import 'package:string_search_algorithms/src/similarity/metrics/cosine.dart';
import 'package:string_search_algorithms/src/similarity/metrics/damerau_levenshtein.dart';
import 'package:string_search_algorithms/src/similarity/metrics/dice_coefficient.dart';
import 'package:string_search_algorithms/src/similarity/metrics/hamming.dart';
import 'package:string_search_algorithms/src/similarity/metrics/jaccard.dart';
import 'package:string_search_algorithms/src/similarity/metrics/jaro.dart';
import 'package:string_search_algorithms/src/similarity/metrics/jaro_winkler.dart';
import 'package:string_search_algorithms/src/similarity/metrics/lcs.dart';
import 'package:string_search_algorithms/src/similarity/metrics/levenshtein.dart';
import 'package:string_search_algorithms/src/similarity/metrics/metaphone.dart';
import 'package:string_search_algorithms/src/similarity/metrics/ngram.dart';
import 'package:string_search_algorithms/src/similarity/metrics/osa.dart';
import 'package:string_search_algorithms/src/similarity/metrics/overlap_coefficient.dart';
import 'package:string_search_algorithms/src/similarity/metrics/soundex.dart';
import 'package:string_search_algorithms/src/similarity/metrics/tversky.dart';

/// Registry for mapping [SimilarityAlgorithm] enums to [SimilarityMetric]
/// implementations.
class SimilarityMetricRegistry {
  /// Creates a registry with an optional initial map of [metrics].
  SimilarityMetricRegistry(
      [Map<SimilarityAlgorithm, SimilarityMetric>? metrics])
      : _metrics = Map<SimilarityAlgorithm, SimilarityMetric>.from(
          metrics ?? const <SimilarityAlgorithm, SimilarityMetric>{},
        );

  /// Creates a registry populated with all built-in algorithms.
  factory SimilarityMetricRegistry.builtIn() {
    return SimilarityMetricRegistry(<SimilarityAlgorithm, SimilarityMetric>{
      SimilarityAlgorithm.diceCoefficient: DiceCoefficientMetric(),
      SimilarityAlgorithm.levenshtein: LevenshteinMetric(),
      SimilarityAlgorithm.damerauLevenshtein: DamerauLevenshteinMetric(),
      SimilarityAlgorithm.osa: OsaMetric(),
      SimilarityAlgorithm.jaro: JaroMetric(),
      SimilarityAlgorithm.jaroWinkler: JaroWinklerMetric(),
      SimilarityAlgorithm.cosine: CosineMetric(),
      SimilarityAlgorithm.jaccard: JaccardMetric(),
      SimilarityAlgorithm.overlapCoefficient: OverlapCoefficientMetric(),
      SimilarityAlgorithm.tversky: TverskyMetric(),
      SimilarityAlgorithm.ngram: NgramMetric(),
      SimilarityAlgorithm.hamming: HammingMetric(),
      SimilarityAlgorithm.lcs: LcsMetric(),
      SimilarityAlgorithm.soundex: SoundexMetric(),
      SimilarityAlgorithm.metaphone: MetaphoneMetric(),
      SimilarityAlgorithm.composite: CompositeMetric(),
    });
  }

  final Map<SimilarityAlgorithm, SimilarityMetric> _metrics;

  /// Returns the [SimilarityMetric] for the given [algorithm].
  ///
  /// Throws [AlgorithmNotSupportedException] if not registered.
  SimilarityMetric metricFor(SimilarityAlgorithm algorithm) {
    final metric = _metrics[algorithm];
    if (metric == null) {
      throw AlgorithmNotSupportedException(
        'Similarity algorithm is not supported/registered.',
        {'algorithm': algorithm.name},
      );
    }
    return metric;
  }

  /// Registers a [metric] for the given [algorithm].
  void register(SimilarityAlgorithm algorithm, SimilarityMetric metric) {
    _metrics[algorithm] = metric;
  }

  /// Returns true if [algorithm] is registered.
  bool supports(SimilarityAlgorithm algorithm) =>
      _metrics.containsKey(algorithm);

  /// Returns a list of all supported algorithms.
  Iterable<SimilarityAlgorithm> get supportedAlgorithms => _metrics.keys;
}
