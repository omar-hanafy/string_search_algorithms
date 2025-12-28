import 'dart:math' as math;

import '../context.dart';
import 'similarity_metric.dart';

class DamerauLevenshteinMetric implements SimilarityMetric {
  @override
  String get id => 'damerau_levenshtein';

  @override
  double score(SimilarityContext ctx) {
    final a = ctx.normalizedA;
    final b = ctx.normalizedB;

    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;
    if (identical(a, b) || a == b) return 1.0;

    final distance = _damerauLevenshteinDistance(a, b);
    final maxLen = math.max(a.length, b.length);
    if (maxLen == 0) return 1.0;

    final sim = 1.0 - (distance / maxLen);
    if (sim <= 0.0) return 0.0;
    if (sim >= 1.0) return 1.0;
    return sim;
  }
}

int _damerauLevenshteinDistance(String s, String t) {
  final a = s.codeUnits;
  final b = t.codeUnits;

  final m = a.length;
  final n = b.length;

  if (m == 0) return n;
  if (n == 0) return m;

  final inf = m + n;

  // Matrix is (m + 2) x (n + 2)
  final d = List<List<int>>.generate(
    m + 2,
    (_) => List<int>.filled(n + 2, 0),
    growable: false,
  );

  d[0][0] = inf;

  for (var i = 0; i <= m; i++) {
    d[i + 1][0] = inf;
    d[i + 1][1] = i;
  }
  for (var j = 0; j <= n; j++) {
    d[0][j + 1] = inf;
    d[1][j + 1] = j;
  }

  // lastRow[codeUnit] = last row index (in 1..m) where codeUnit appeared in s
  final lastRow = <int, int>{};
  for (final c in a) {
    lastRow[c] = 0;
  }
  for (final c in b) {
    lastRow[c] = 0;
  }

  for (var i = 1; i <= m; i++) {
    var db = 0; // last column with a matching character in current row
    final ai = a[i - 1];

    for (var j = 1; j <= n; j++) {
      final bj = b[j - 1];

      final i1 = lastRow[bj] ?? 0;
      final j1 = db;

      var cost = 1;
      if (ai == bj) {
        cost = 0;
        db = j;
      }

      final substitution = d[i][j] + cost;
      final insertion = d[i + 1][j] + 1;
      final deletion = d[i][j + 1] + 1;

      // True Damerau-Levenshtein transposition term.
      final transposition =
          d[i1][j1] + (i - i1 - 1) + 1 + (j - j1 - 1);

      d[i + 1][j + 1] =
          _min4(substitution, insertion, deletion, transposition);
    }

    lastRow[ai] = i;
  }

  return d[m + 1][n + 1];
}

int _min4(int a, int b, int c, int d) {
  var m = a < b ? a : b;
  m = m < c ? m : c;
  return m < d ? m : d;
}
