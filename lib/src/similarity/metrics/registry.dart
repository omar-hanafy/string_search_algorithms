// lib/src/similarity/metrics/registry.dart
import '../../common/exceptions.dart';
import '../../common/typedefs.dart';
import 'similarity_metric.dart';

// Built-in metrics
import 'cosine.dart';
import 'damerau_levenshtein.dart';
import 'dice_coefficient.dart';
import 'hamming.dart';
import 'jaccard.dart';
import 'jaro.dart';
import 'jaro_winkler.dart';
import 'lcs.dart';
import 'levenshtein.dart';
import 'metaphone.dart';
import 'ngram.dart';
import 'osa.dart';
import 'overlap_coefficient.dart';
import 'soundex.dart';
import 'tversky.dart';

class SimilarityMetricRegistry {
  SimilarityMetricRegistry([Map<SimilarityAlgorithm, SimilarityMetric>? metrics])
      : _metrics = Map<SimilarityAlgorithm, SimilarityMetric>.from(
          metrics ?? const <SimilarityAlgorithm, SimilarityMetric>{},
        );

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
    });
  }

  final Map<SimilarityAlgorithm, SimilarityMetric> _metrics;

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

  void register(SimilarityAlgorithm algorithm, SimilarityMetric metric) {
    _metrics[algorithm] = metric;
  }

  bool supports(SimilarityAlgorithm algorithm) => _metrics.containsKey(algorithm);

  Iterable<SimilarityAlgorithm> get supportedAlgorithms => _metrics.keys;
}
