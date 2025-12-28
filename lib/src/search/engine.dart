import 'package:string_search_algorithms/src/common/exceptions.dart';
import 'package:string_search_algorithms/src/search/algorithms/boyer_moore.dart';
import 'package:string_search_algorithms/src/search/algorithms/kmp.dart';
import 'package:string_search_algorithms/src/search/algorithms/rabin_karp.dart';
import 'package:string_search_algorithms/src/search/algorithms/search_algorithm.dart';
import 'package:string_search_algorithms/src/search/models/compiled_pattern.dart';
import 'package:string_search_algorithms/src/search/models/search_match.dart';

/// Engine for performing substring searches using various algorithms.
class StringSearchEngine {
  /// Creates a [StringSearchEngine].
  const StringSearchEngine();

  /// Compiles a [pattern] into a [CompiledPattern] using the specified
  /// [algorithm].
  ///
  /// This allows reusing the pre-processing steps of the algorithm for multiple
  /// searches.
  ///
  /// Example:
  /// ```dart
  /// final engine = StringSearchEngine();
  /// final compiled = engine.compile('world');
  /// ```
  ///
  /// Throws [InvalidInputException] if [pattern] is empty.
  CompiledPattern compile(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    if (pattern.isEmpty) {
      throw InvalidInputException(
        'Pattern must not be empty for compile().',
        {'pattern': pattern},
      );
    }

    switch (algorithm) {
      case SearchAlgorithm.kmp:
        return compileKmp(pattern);
      case SearchAlgorithm.boyerMoore:
        return compileBoyerMoore(pattern);
      case SearchAlgorithm.rabinKarp:
        return compileRabinKarp(pattern);
    }
  }

  /// Finds the first index of [pattern] in [text], starting from [start].
  ///
  /// Returns -1 if not found. An empty [pattern] returns [start], matching
  /// Dart String behavior.
  ///
  /// Throws [InvalidInputException] if [start] is outside
  /// `0 <= start <= text.length`.
  ///
  /// Example:
  /// ```dart
  /// engine.indexOf('hello world', 'world'); // 6
  /// ```
  int indexOf(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    _validateStart(text, start);

    // Spec: empty pattern returns start.
    if (pattern.isEmpty) return start;

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.indexOfIn(text, start: start);
  }

  /// Returns true if [pattern] is found in [text], starting from [start].
  ///
  /// Example:
  /// ```dart
  /// engine.contains('hello world', 'world'); // true
  /// ```
  bool contains(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    _validateStart(text, start);

    // Spec: empty pattern returns true.
    if (pattern.isEmpty) return true;

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.containsIn(text, start: start);
  }

  /// Returns all matches of [pattern] in [text].
  ///
  /// Example:
  /// ```dart
  /// engine.findAll('ababa', 'aba');
  /// // [SearchMatch(index: 0), SearchMatch(index: 2)]
  /// ```
  ///
  /// Throws [InvalidInputException] if [pattern] is empty.
  List<SearchMatch> findAll(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    // Spec: findAll with empty pattern throws.
    if (pattern.isEmpty) {
      throw InvalidInputException(
        'Pattern must not be empty for findAll().',
        {'pattern': pattern},
      );
    }

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.findAllIn(text);
  }

  /// Returns all start indices of [pattern] in [text].
  ///
  /// Example:
  /// ```dart
  /// engine.findAllIndices('ababa', 'aba'); // [0, 2]
  /// ```
  ///
  /// Throws [InvalidInputException] if [pattern] is empty.
  List<int> findAllIndices(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    // Spec: findAllIndices with empty pattern throws.
    if (pattern.isEmpty) {
      throw InvalidInputException(
        'Pattern must not be empty for findAllIndices().',
        {'pattern': pattern},
      );
    }

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.findAllIndicesIn(text);
  }

  static void _validateStart(String text, int start) {
    // Spec: start must be 0 <= start <= text.length (inclusive).
    if (start < 0 || start > text.length) {
      throw InvalidInputException(
        'Invalid start index. Must satisfy 0 <= start <= text.length.',
        {'start': start, 'textLength': text.length},
      );
    }
  }
}
