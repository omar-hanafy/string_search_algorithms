import '../context.dart';
import 'similarity_metric.dart';

class HammingMetric implements SimilarityMetric {
  @override
  String get id => 'hamming';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.length != b.length) return 0.0;
    if (identical(a, b) || a == b) return 1.0;

    final au = a.codeUnits;
    final bu = b.codeUnits;

    var distance = 0;
    for (var i = 0; i < au.length; i++) {
      if (au[i] != bu[i]) distance++;
    }

    if (au.isEmpty) return 1.0;
    final sim = 1.0 - (distance / au.length);
    if (sim <= 0.0) return 0.0;
    if (sim >= 1.0) return 1.0;
    return sim;
  }
}
