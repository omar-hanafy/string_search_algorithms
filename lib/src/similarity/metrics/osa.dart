import 'dart:math' as math;

import '../context.dart';
import 'similarity_metric.dart';

class OsaMetric implements SimilarityMetric {
  @override
  String get id => 'osa';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;
    if (identical(a, b) || a == b) return 1.0;

    final distance = _osaDistance(a, b);
    final maxLen = math.max(a.length, b.length);
    if (maxLen == 0) return 1.0;

    final sim = 1.0 - (distance / maxLen);
    if (sim <= 0.0) return 0.0;
    if (sim >= 1.0) return 1.0;
    return sim;
  }
}

int _osaDistance(String s, String t) {
  final a = s.codeUnits;
  final b = t.codeUnits;

  final m = a.length;
  final n = b.length;

  if (m == 0) return n;
  if (n == 0) return m;

  // OSA requires (i-2, j-2), so keep 3 rows.
  var prev = List<int>.generate(n + 1, (j) => j, growable: false);
  var prevPrev = List<int>.from(prev, growable: false);
  var curr = List<int>.filled(n + 1, 0, growable: false);

  for (var i = 1; i <= m; i++) {
    curr[0] = i;

    for (var j = 1; j <= n; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;

      var best = math.min(
        math.min(curr[j - 1] + 1, prev[j] + 1),
        prev[j - 1] + cost,
      );

      // Adjacent transposition (OSA)
      if (i > 1 &&
          j > 1 &&
          a[i - 1] == b[j - 2] &&
          a[i - 2] == b[j - 1]) {
        best = math.min(best, prevPrev[j - 2] + 1);
      }

      curr[j] = best;
    }

    // Rotate rows: prevPrev <- prev, prev <- curr, curr <- old prevPrev
    final tmp = prevPrev;
    prevPrev = prev;
    prev = curr;
    curr = tmp;
  }

  return prev[n];
}
