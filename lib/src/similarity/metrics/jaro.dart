import 'dart:math';

import 'package:string_search_algorithms/src/similarity/context.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';

/// Implements the Jaro Similarity metric.
class JaroMetric implements SimilarityMetric {
  @override
  String get id => 'jaro';

  @override
  double score(SimilarityContext ctx) {
    final s1 = ctx.normalizedA;
    final s2 = ctx.normalizedB;

    if (s1 == s2) return 1.0;
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final len1 = s1.length;
    final len2 = s2.length;

    // Jaro match window: floor(max(len1,len2)/2) - 1, clamped to >= 0
    final matchDistance = max(0, (max(len1, len2) ~/ 2) - 1);

    final matches1 = List<bool>.filled(len1, false);
    final matches2 = List<bool>.filled(len2, false);

    var matches = 0;

    for (var i = 0; i < len1; i++) {
      final start = max(0, i - matchDistance);
      final end = min(i + matchDistance + 1, len2);

      final c1 = s1.codeUnitAt(i);

      for (var j = start; j < end; j++) {
        if (matches2[j]) continue;
        if (c1 == s2.codeUnitAt(j)) {
          matches1[i] = true;
          matches2[j] = true;
          matches++;
          break;
        }
      }
    }

    if (matches == 0) return 0.0;

    // Count transpositions
    var k = 0;
    var transpositions = 0;

    for (var i = 0; i < len1; i++) {
      if (!matches1[i]) continue;

      while (k < len2 && !matches2[k]) {
        k++;
      }

      if (k < len2 && s1.codeUnitAt(i) != s2.codeUnitAt(k)) {
        transpositions++;
      }
      k++;
    }

    final m = matches.toDouble();
    final t = transpositions / 2.0;

    return (m / len1 + m / len2 + (m - t) / m) / 3.0;
  }
}
