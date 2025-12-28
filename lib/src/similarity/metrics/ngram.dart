import '../context.dart';
import 'similarity_metric.dart';

class NgramMetric implements SimilarityMetric {
  @override
  String get id => 'ngram';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a == b) return 1.0;
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final n = ctx.options.algorithms.ngramSize;

    // If either string is shorter than n, the only way they can be "identical"
    // was already handled above (a == b). Treat remaining cases as no match.
    if (a.length < n || b.length < n) return 0.0;

    final gramsA = ctx.ngrams(a, n: n).toSet();
    final gramsB = ctx.ngrams(b, n: n).toSet();

    if (gramsA.isEmpty && gramsB.isEmpty) return 1.0;
    if (gramsA.isEmpty || gramsB.isEmpty) return 0.0;

    final intersection = gramsA.intersection(gramsB).length;
    final union = gramsA.union(gramsB).length;

    if (union == 0) return 0.0;
    return intersection / union;
  }
}
