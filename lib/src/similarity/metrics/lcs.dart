import 'dart:math' as math;

import '../context.dart';
import 'similarity_metric.dart';

class LcsMetric implements SimilarityMetric {
  @override
  String get id => 'lcs';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;
    if (identical(a, b) || a == b) return 1.0;

    final lcsLen = _lcsLength(a, b);
    final maxLen = math.max(a.length, b.length);
    if (maxLen == 0) return 1.0;

    final sim = lcsLen / maxLen;
    if (sim <= 0.0) return 0.0;
    if (sim >= 1.0) return 1.0;
    return sim;
  }
}

int _lcsLength(String a, String b) {
  final au = a.codeUnits;
  final bu = b.codeUnits;

  final m = au.length;
  final n = bu.length;

  if (m == 0 || n == 0) return 0;

  // Space-optimized DP: two rows.
  var prev = List<int>.filled(n + 1, 0, growable: false);
  var curr = List<int>.filled(n + 1, 0, growable: false);

  for (var i = 1; i <= m; i++) {
    final ai = au[i - 1];
    for (var j = 1; j <= n; j++) {
      if (ai == bu[j - 1]) {
        curr[j] = prev[j - 1] + 1;
      } else {
        curr[j] = math.max(prev[j], curr[j - 1]);
      }
    }
    final tmp = prev;
    prev = curr;
    curr = tmp;
    // Reset for next iteration.
    curr.fillRange(0, n + 1, 0);
  }

  return prev[n];
}
