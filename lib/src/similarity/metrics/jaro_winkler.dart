import 'dart:math';

import '../context.dart';
import 'similarity_metric.dart';

class JaroWinklerMetric implements SimilarityMetric {
  @override
  String get id => 'jaro_winkler';

  @override
  double score(SimilarityContext ctx) {
    final s1 = ctx.normalizedA;
    final s2 = ctx.normalizedB;

    if (s1 == s2) return 1.0;
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final base = _jaro(s1, s2);
    final prefixScale = ctx.options.algorithms.jaroWinklerPrefixScale;
    final boostThreshold = ctx.options.algorithms.jaroWinklerBoostThreshold;

    if (base < boostThreshold) return base;

    // Common prefix length up to 4 characters.
    const prefixLimit = 4;
    final maxPrefix = min(prefixLimit, min(s1.length, s2.length));

    var prefix = 0;
    for (var i = 0; i < maxPrefix; i++) {
      if (s1.codeUnitAt(i) == s2.codeUnitAt(i)) {
        prefix++;
      } else {
        break;
      }
    }

    // Winkler adjustment: J + l*p*(1-J)
    return base + (prefix * prefixScale * (1 - base));
  }

  double _jaro(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final len1 = s1.length;
    final len2 = s2.length;

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
