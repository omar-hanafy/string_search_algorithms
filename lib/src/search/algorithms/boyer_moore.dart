import '../../common/exceptions.dart';
import '../models/compiled_pattern.dart';
import '../models/search_match.dart';
import 'search_algorithm.dart';

/// Compiles [pattern] into a Boyer–Moore compiled pattern.
///
/// Throws [InvalidInputException] if [pattern] is empty.
CompiledPattern compileBoyerMoore(String pattern) {
  if (pattern.isEmpty) {
    throw InvalidInputException(
      'Pattern must not be empty for Boyer–Moore compilation.',
      {'pattern': pattern},
    );
  }
  return _BoyerMooreCompiledPattern(pattern);
}

class _BoyerMooreCompiledPattern implements CompiledPattern {
  _BoyerMooreCompiledPattern(this.pattern)
      : _pat = pattern.codeUnits,
        _m = pattern.length,
        _badCharLast = _buildBadCharLast(pattern.codeUnits),
        _goodSuffixShift = _buildGoodSuffixShift(pattern.codeUnits);

  @override
  final String pattern;

  final List<int> _pat;
  final int _m;

  /// Bad-character rule: codeUnit -> last occurrence index in pattern.
  final Map<int, int> _badCharLast;

  /// Good-suffix shift table; index is mismatch position j in the pattern.
  final List<int> _goodSuffixShift;

  @override
  SearchAlgorithm get algorithm => SearchAlgorithm.boyerMoore;

  @override
  int indexOfIn(String text, {int start = 0}) {
    _validateStart(text, start);

    final n = text.length;
    if (start == n) return -1;
    if (_m > n - start) return -1;

    var i = start; // alignment index in text

    while (i <= n - _m) {
      var j = _m - 1;

      // Scan pattern from right to left.
      while (j >= 0 && _pat[j] == text.codeUnitAt(i + j)) {
        j--;
      }

      // Full match.
      if (j < 0) return i;

      // Mismatch at pattern index j.
      final mismatched = text.codeUnitAt(i + j);
      final last = _badCharLast[mismatched] ?? -1;

      final badShift = j - last;
      final goodShift = _goodSuffixShift[j];

      var shift = badShift > goodShift ? badShift : goodShift;
      if (shift < 1) shift = 1;

      i += shift;
    }

    return -1;
  }

  @override
  bool containsIn(String text, {int start = 0}) =>
      indexOfIn(text, start: start) >= 0;

  @override
  List<SearchMatch> findAllIn(String text) {
    final n = text.length;
    if (_m > n) return const <SearchMatch>[];

    final matches = <SearchMatch>[];
    var i = 0;

    while (i <= n - _m) {
      var j = _m - 1;

      while (j >= 0 && _pat[j] == text.codeUnitAt(i + j)) {
        j--;
      }

      if (j < 0) {
        // Match found at i.
        matches.add(
          SearchMatch(
            index: i,
            length: _m,
            algorithm: SearchAlgorithm.boyerMoore,
          ),
        );

        // IMPORTANT (Spec): allow overlapping matches => shift by exactly 1.
        i += 1;
        continue;
      }

      final mismatched = text.codeUnitAt(i + j);
      final last = _badCharLast[mismatched] ?? -1;

      final badShift = j - last;
      final goodShift = _goodSuffixShift[j];

      var shift = badShift > goodShift ? badShift : goodShift;
      if (shift < 1) shift = 1;

      i += shift;
    }

    return matches;
  }

  @override
  List<int> findAllIndicesIn(String text) {
    final matches = findAllIn(text);
    if (matches.isEmpty) return const <int>[];
    return matches.map((m) => m.index).toList(growable: false);
  }

  static void _validateStart(String text, int start) {
    if (start < 0 || start > text.length) {
      throw InvalidInputException(
        'Start must be between 0 and text.length (inclusive).',
        {'start': start, 'textLength': text.length},
      );
    }
  }

  static Map<int, int> _buildBadCharLast(List<int> pat) {
    final last = <int, int>{};
    for (var i = 0; i < pat.length; i++) {
      last[pat[i]] = i;
    }
    return last;
  }

  /// Builds Boyer–Moore good-suffix shift table.
  ///
  /// `shift[j]` is the shift distance when mismatch occurs at pattern index `j`.
  static List<int> _buildGoodSuffixShift(List<int> pat) {
    final m = pat.length;
    if (m == 1) return <int>[1];

    final suff = _suffixes(pat);
    final shift = List<int>.filled(m, m);

    var j = 0;

    // Case 1: suffix is also a prefix.
    for (var i = m - 1; i >= 0; --i) {
      if (suff[i] == i + 1) {
        for (; j < m - 1 - i; ++j) {
          if (shift[j] == m) {
            shift[j] = m - 1 - i;
          }
        }
      }
    }

    // Case 2: other suffixes.
    for (var i = 0; i <= m - 2; ++i) {
      shift[m - 1 - suff[i]] = m - 1 - i;
    }

    // Ensure progress.
    for (var i = 0; i < shift.length; i++) {
      if (shift[i] <= 0) shift[i] = 1;
    }

    return shift;
  }

  /// Computes suffix lengths for good-suffix preprocessing.
  static List<int> _suffixes(List<int> pat) {
    final m = pat.length;
    final suff = List<int>.filled(m, 0);

    suff[m - 1] = m;
    var g = m - 1;
    var f = 0;

    for (var i = m - 2; i >= 0; --i) {
      if (i > g && suff[i + m - 1 - f] < i - g) {
        suff[i] = suff[i + m - 1 - f];
      } else {
        if (i < g) g = i;
        f = i;
        while (g >= 0 && pat[g] == pat[g + m - 1 - f]) {
          --g;
        }
        suff[i] = f - g;
      }
    }

    return suff;
  }
}
