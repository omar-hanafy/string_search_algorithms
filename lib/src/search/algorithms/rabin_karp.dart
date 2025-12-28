import 'package:string_search_algorithms/src/search/models/compiled_pattern.dart';

import 'package:string_search_algorithms/src/common/exceptions.dart';
import 'package:string_search_algorithms/src/search/models/search_match.dart';
import 'package:string_search_algorithms/src/search/algorithms/search_algorithm.dart';

/// Compiles [pattern] into a Rabin-Karp compiled pattern.
///
/// Throws [InvalidInputException] if [pattern] is empty.
CompiledPattern compileRabinKarp(String pattern) {
  if (pattern.isEmpty) {
    throw InvalidInputException(
      'Pattern must not be empty for compileRabinKarp().',
      {'pattern': pattern},
    );
  }
  return _RabinKarpCompiledPattern(pattern);
}

class _RabinKarpCompiledPattern implements CompiledPattern {
  _RabinKarpCompiledPattern(String pattern)
      : _pattern = pattern,
        _m = pattern.length,
        _patternHash = _hash(pattern, _base, _mod),
        _highOrderFactor = _computeHighOrderFactor(pattern.length, _base, _mod);

  static const int _base = 256;
  // 2^31 - 1 (prime). Safe under JS number integer precision constraints.
  static const int _mod = 2147483647;

  final String _pattern;
  final int _m;
  final int _patternHash;
  final int _highOrderFactor;

  @override
  String get pattern => _pattern;

  @override
  SearchAlgorithm get algorithm => SearchAlgorithm.rabinKarp;

  @override
  int indexOfIn(String text, {int start = 0}) {
    _validateStart(text, start);

    if (_m == 0) return start; // defensive; compile disallows empty patterns
    if (text.length - start < _m) return -1;

    var windowHash = _hashWindow(text, start, _m, _base, _mod);

    final lastStart = text.length - _m;
    for (var i = start; i <= lastStart; i++) {
      if (windowHash == _patternHash && text.startsWith(_pattern, i)) {
        return i;
      }

      if (i < lastStart) {
        final leading = text.codeUnitAt(i);
        final trailing = text.codeUnitAt(i + _m);
        windowHash = _roll(
          currentHash: windowHash,
          leadingCodeUnit: leading,
          trailingCodeUnit: trailing,
          highOrderFactor: _highOrderFactor,
          base: _base,
          mod: _mod,
        );
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

    return <SearchMatch>[
      for (final idx in indices)
        SearchMatch(index: idx, length: _m, algorithm: algorithm),
    ];
  }

  @override
  List<int> findAllIndicesIn(String text) {
    if (_m == 0) {
      // defensive; compile disallows empty patterns
      throw InvalidInputException(
        'Pattern must not be empty for Rabin-Karp findAllIndicesIn().',
      );
    }
    if (text.length < _m) return const <int>[];

    final matches = <int>[];

    var windowHash = _hashWindow(text, 0, _m, _base, _mod);
    final lastStart = text.length - _m;

    for (var i = 0; i <= lastStart; i++) {
      if (windowHash == _patternHash && text.startsWith(_pattern, i)) {
        matches.add(i);
      }

      if (i < lastStart) {
        final leading = text.codeUnitAt(i);
        final trailing = text.codeUnitAt(i + _m);
        windowHash = _roll(
          currentHash: windowHash,
          leadingCodeUnit: leading,
          trailingCodeUnit: trailing,
          highOrderFactor: _highOrderFactor,
          base: _base,
          mod: _mod,
        );
      }
    }

    return matches;
  }

  static int _computeHighOrderFactor(int m, int base, int mod) {
    // base^(m-1) % mod
    var h = 1;
    for (var i = 0; i < m - 1; i++) {
      h = (h * base) % mod;
    }
    return h;
  }

  static int _hash(String input, int base, int mod) {
    var hash = 0;
    for (var i = 0; i < input.length; i++) {
      hash = (hash * base + input.codeUnitAt(i)) % mod;
    }
    return hash;
  }

  static int _hashWindow(
      String text, int start, int length, int base, int mod) {
    var hash = 0;
    final end = start + length;
    for (var i = start; i < end; i++) {
      hash = (hash * base + text.codeUnitAt(i)) % mod;
    }
    return hash;
  }

  static int _roll({
    required int currentHash,
    required int leadingCodeUnit,
    required int trailingCodeUnit,
    required int highOrderFactor,
    required int base,
    required int mod,
  }) {
    // Remove leading char contribution.
    var hash = currentHash - ((leadingCodeUnit * highOrderFactor) % mod);
    hash %= mod;
    if (hash < 0) hash += mod;

    // Add trailing char.
    hash = (hash * base + trailingCodeUnit) % mod;
    return hash;
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
