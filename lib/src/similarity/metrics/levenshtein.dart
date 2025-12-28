import 'dart:math';

import '../context.dart';
import 'similarity_metric.dart';

class LevenshteinMetric implements SimilarityMetric {
  @override
  String get id => 'levenshtein';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a == b) return 1.0;

    final lenA = a.length;
    final lenB = b.length;

    if (lenA == 0 && lenB == 0) return 1.0;
    if (lenA == 0 || lenB == 0) return 0.0;

    final dist = _distance(a, b);
    final maxLen = max(lenA, lenB);
    if (maxLen == 0) return 1.0;

    final sim = 1.0 - (dist / maxLen);

    // Clamp for safety against floating point drift.
    if (sim < 0.0) return 0.0;
    if (sim > 1.0) return 1.0;
    return sim;
  }

  int _distance(String s1, String s2) {
    // Use the shorter string for the row size (lower memory).
    var a = s1;
    var b = s2;

    if (a.length < b.length) {
      final tmp = a;
      a = b;
      b = tmp;
    }

    final m = a.length;
    final n = b.length;

    // n is the smaller dimension.
    var prev = List<int>.generate(n + 1, (i) => i);
    var curr = List<int>.filled(n + 1, 0);

    for (var i = 0; i < m; i++) {
      curr[0] = i + 1;
      final aCode = a.codeUnitAt(i);

      for (var j = 0; j < n; j++) {
        final cost = aCode == b.codeUnitAt(j) ? 0 : 1;

        final del = prev[j + 1] + 1;
        final ins = curr[j] + 1;
        final sub = prev[j] + cost;

        curr[j + 1] = min(min(del, ins), sub);
      }

      final tmp = prev;
      prev = curr;
      curr = tmp;
    }

    return prev[n];
  }
}
