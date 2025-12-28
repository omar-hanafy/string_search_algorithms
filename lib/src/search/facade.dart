import 'package:string_search_algorithms/src/search/algorithms/search_algorithm.dart';
import 'package:string_search_algorithms/src/search/engine.dart';
import 'package:string_search_algorithms/src/search/models/compiled_pattern.dart';
import 'package:string_search_algorithms/src/search/models/search_match.dart';

/// Static facade for common string search operations.
///
/// Use [StringSearchEngine] for instance-based usage or advanced
/// configuration.
class StringSearch {
  static const StringSearchEngine _engine = StringSearchEngine();

  /// Compiles a [pattern] into a [CompiledPattern] using the specified
  /// [algorithm].
  ///
  /// Example:
  /// ```dart
  /// final pattern = StringSearch.compile('world');
  /// pattern.indexOfIn('hello world'); // 6
  /// ```
  ///
  /// Throws InvalidInputException if [pattern] is empty.
  static CompiledPattern compile(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return _engine.compile(pattern, algorithm: algorithm);
  }

  /// Finds the first index of [pattern] in [text].
  ///
  /// Example:
  /// ```dart
  /// StringSearch.indexOf('hello world', 'world'); // 6
  /// ```
  ///
  /// Returns -1 if not found. An empty [pattern] returns [start].
  static int indexOf(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    return _engine.indexOf(
      text,
      pattern,
      algorithm: algorithm,
      start: start,
    );
  }

  /// Returns true if [pattern] is found in [text].
  ///
  /// Example:
  /// ```dart
  /// StringSearch.contains('hello world', 'world'); // true
  /// ```
  /// An empty [pattern] returns true.
  static bool contains(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    return _engine.contains(
      text,
      pattern,
      algorithm: algorithm,
      start: start,
    );
  }

  /// Returns all matches of [pattern] in [text].
  ///
  /// Example:
  /// ```dart
  /// final matches = StringSearch.findAll('ababa', 'aba');
  /// // Two matches at indices 0 and 2.
  /// ```
  ///
  /// Throws InvalidInputException if [pattern] is empty.
  static List<SearchMatch> findAll(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return _engine.findAll(
      text,
      pattern,
      algorithm: algorithm,
    );
  }

  /// Returns all start indices of matches of [pattern] in [text].
  ///
  /// Example:
  /// ```dart
  /// StringSearch.findAllIndices('ababa', 'aba'); // [0, 2]
  /// ```
  ///
  /// Throws InvalidInputException if [pattern] is empty.
  static List<int> findAllIndices(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return _engine.findAllIndices(
      text,
      pattern,
      algorithm: algorithm,
    );
  }
}
