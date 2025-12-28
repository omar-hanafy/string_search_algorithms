import 'dart:math' as math;

import '../context.dart';
import 'similarity_metric.dart';

class CosineMetric implements SimilarityMetric {
  @override
  String get id => 'cosine';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a == b) return 1.0;
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final tokensA = ctx.tokens(a);
    final tokensB = ctx.tokens(b);

    if (tokensA.isEmpty && tokensB.isEmpty) return 1.0;
    if (tokensA.isEmpty || tokensB.isEmpty) return 0.0;

    final freqA = _frequency(tokensA);
    final freqB = _frequency(tokensB);

    final allKeys = <String>{...freqA.keys, ...freqB.keys};

    double dot = 0.0;
    double magA = 0.0;
    double magB = 0.0;

    for (final key in allKeys) {
      final aCount = (freqA[key] ?? 0).toDouble();
      final bCount = (freqB[key] ?? 0).toDouble();
      dot += aCount * bCount;
      magA += aCount * aCount;
      magB += bCount * bCount;
    }

    final denom = math.sqrt(magA) * math.sqrt(magB);
    if (denom == 0.0) return 0.0;

    return _clamp01(dot / denom);
  }

  Map<String, int> _frequency(List<String> tokens) {
    final map = <String, int>{};
    for (final t in tokens) {
      map[t] = (map[t] ?? 0) + 1;
    }
    return map;
  }

  double _clamp01(double v) {
    if (v.isNaN) return 0.0;
    if (v < 0.0) return 0.0;
    if (v > 1.0) return 1.0;
    return v;
  }
}
