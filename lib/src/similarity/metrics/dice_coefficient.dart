import 'dart:math';

import '../context.dart';
import 'similarity_metric.dart';

class DiceCoefficientMetric implements SimilarityMetric {
  @override
  String get id => 'dice_coefficient';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a == b) return 1.0;
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    // For very short strings, bigram-based similarity is not meaningful.
    if (a.length < 2 || b.length < 2) {
      return a == b ? 1.0 : 0.0;
    }

    final aBigrams = ctx.bigramCounts(a);
    final bBigrams = ctx.bigramCounts(b);

    if (aBigrams.isEmpty && bBigrams.isEmpty) {
      return a == b ? 1.0 : 0.0;
    }
    if (aBigrams.isEmpty || bBigrams.isEmpty) {
      return 0.0;
    }

    var intersection = 0;
    var countA = 0;
    for (final entry in aBigrams.entries) {
      countA += entry.value;
      final countInB = bBigrams[entry.key];
      if (countInB != null) {
        intersection += min(entry.value, countInB);
      }
    }

    var countB = 0;
    for (final v in bBigrams.values) {
      countB += v;
    }

    final denom = countA + countB;
    if (denom == 0) return 0.0;

    return (2.0 * intersection) / denom;
  }
}
