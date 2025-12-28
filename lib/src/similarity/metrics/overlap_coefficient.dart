import 'package:string_search_algorithms/src/similarity/context.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';

/// Implements the Overlap Coefficient (subset similarity).
class OverlapCoefficientMetric implements SimilarityMetric {
  @override
  String get id => 'overlap_coefficient';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a == b) return 1.0;
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final setA = ctx.ngrams(a, n: ctx.options.algorithms.ngramSize).toSet();
    final setB = ctx.ngrams(b, n: ctx.options.algorithms.ngramSize).toSet();

    if (setA.isEmpty && setB.isEmpty) return 1.0;
    if (setA.isEmpty || setB.isEmpty) return 0.0;

    final intersection = setA.intersection(setB).length;
    final denom = setA.length < setB.length ? setA.length : setB.length;

    if (denom == 0) return 0.0;
    return intersection / denom;
  }
}
