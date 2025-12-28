import '../context.dart';
import 'similarity_metric.dart';

class JaccardMetric implements SimilarityMetric {
  @override
  String get id => 'jaccard';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a == b) return 1.0;
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final setA = ctx.tokens(a).toSet();
    final setB = ctx.tokens(b).toSet();

    if (setA.isEmpty && setB.isEmpty) return 1.0;
    if (setA.isEmpty || setB.isEmpty) return 0.0;

    final intersection = setA.intersection(setB).length;
    final union = setA.union(setB).length;

    if (union == 0) return 0.0;
    return intersection / union;
  }
}
