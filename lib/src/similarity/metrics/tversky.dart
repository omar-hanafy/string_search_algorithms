import '../context.dart';
import 'similarity_metric.dart';

class TverskyMetric implements SimilarityMetric {
  @override
  String get id => 'tversky';

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

    final intersection = setA.intersection(setB).length.toDouble();
    final onlyA = setA.difference(setB).length.toDouble();
    final onlyB = setB.difference(setA).length.toDouble();

    final alpha = ctx.options.algorithms.tverskyAlpha;
    final beta = ctx.options.algorithms.tverskyBeta;

    final denom = intersection + (alpha * onlyA) + (beta * onlyB);
    if (denom == 0.0) return 0.0;

    final v = intersection / denom;
    return _clamp01(v);
  }

  double _clamp01(double v) {
    if (v.isNaN) return 0.0;
    if (v < 0.0) return 0.0;
    if (v > 1.0) return 1.0;
    return v;
  }
}
