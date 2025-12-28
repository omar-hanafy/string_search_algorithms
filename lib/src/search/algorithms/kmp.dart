import '../models/compiled_pattern.dart';

import '../../common/exceptions.dart';
import '../models/search_match.dart';
import 'search_algorithm.dart';

CompiledPattern compileKmp(String pattern) {
  if (pattern.isEmpty) {
    throw InvalidInputException(
      'Pattern must not be empty for compileKmp().',
      {'pattern': pattern},
    );
  }
  return _KmpCompiledPattern(pattern);
}

class _KmpCompiledPattern implements CompiledPattern {
  _KmpCompiledPattern(String pattern)
      : _pattern = pattern,
        _patternUnits = pattern.codeUnits,
        _lps = _buildLps(pattern.codeUnits);

  final String _pattern;
  final List<int> _patternUnits;
  final List<int> _lps;

  @override
  String get pattern => _pattern;

  @override
  SearchAlgorithm get algorithm => SearchAlgorithm.kmp;

  @override
  int indexOfIn(String text, {int start = 0}) {
    _validateStart(text, start);

    final m = _patternUnits.length;
    if (m == 0) return start; // defensive; compile disallows empty patterns
    if (text.length - start < m) return -1;

    var i = start; // index for text
    var j = 0; // index for pattern

    while (i < text.length) {
      if (text.codeUnitAt(i) == _patternUnits[j]) {
        i++;
        j++;
        if (j == m) {
          return i - j;
        }
      } else {
        if (j != 0) {
          j = _lps[j - 1];
        } else {
          i++;
        }
      }
    }

    return -1;
  }

  @override
  bool containsIn(String text, {int start = 0}) {
    return indexOfIn(text, start: start) != -1;
  }

  @override
  List<SearchMatch> findAllIn(String text) {
    final indices = findAllIndicesIn(text);
    if (indices.isEmpty) return const <SearchMatch>[];

    final m = _patternUnits.length;
    return <SearchMatch>[
      for (final idx in indices)
        SearchMatch(index: idx, length: m, algorithm: algorithm),
    ];
  }

  @override
  List<int> findAllIndicesIn(String text) {
    final m = _patternUnits.length;
    if (m == 0) {
      // defensive; compile disallows empty patterns
      throw InvalidInputException(
        'Pattern must not be empty for KMP findAllIndicesIn().',
      );
    }
    if (text.length < m) return const <int>[];

    final matches = <int>[];

    var i = 0; // index for text
    var j = 0; // index for pattern

    while (i < text.length) {
      if (text.codeUnitAt(i) == _patternUnits[j]) {
        i++;
        j++;

        if (j == m) {
          // match found at i - j
          matches.add(i - j);

          // allow overlapping matches
          j = _lps[j - 1];
        }
      } else {
        if (j != 0) {
          j = _lps[j - 1];
        } else {
          i++;
        }
      }
    }

    return matches;
  }

  static List<int> _buildLps(List<int> patternUnits) {
    final m = patternUnits.length;
    final lps = List<int>.filled(m, 0);

    var len = 0; // length of the previous longest prefix suffix
    var i = 1;

    while (i < m) {
      if (patternUnits[i] == patternUnits[len]) {
        len++;
        lps[i] = len;
        i++;
      } else {
        if (len != 0) {
          len = lps[len - 1];
        } else {
          lps[i] = 0;
          i++;
        }
      }
    }

    return lps;
  }

  static void _validateStart(String text, int start) {
    if (start < 0 || start > text.length) {
      throw InvalidInputException(
        'Start must be within [0, text.length].',
        {'start': start, 'textLength': text.length},
      );
    }
  }
}
