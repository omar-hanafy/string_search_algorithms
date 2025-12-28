import 'package:string_search_algorithms/src/search/algorithms/search_algorithm.dart';
import 'package:string_search_algorithms/src/search/facade.dart';
import 'package:string_search_algorithms/src/search/models/search_match.dart';

/// Convenience extensions for using [StringSearch] on String instances.
///
/// Note: We intentionally avoid names like `indexOf` / `contains` to prevent
/// confusion with built-in String methods.
extension StringSearchExtensions on String {
  /// Finds the first index of [pattern] in this string using the chosen
  /// algorithm.
  ///
  /// Example:
  /// ```dart
  /// 'hello world'.indexOfPattern('world'); // 6
  /// ```
  int indexOfPattern(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    return StringSearch.indexOf(
      this,
      pattern,
      algorithm: algorithm,
      start: start,
    );
  }

  /// Returns true if [pattern] occurs in this string using the chosen
  /// algorithm.
  ///
  /// Example:
  /// ```dart
  /// 'hello world'.containsPattern('world'); // true
  /// ```
  bool containsPattern(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    return StringSearch.contains(
      this,
      pattern,
      algorithm: algorithm,
      start: start,
    );
  }

  /// Returns all matches (including overlapping matches).
  ///
  /// Example:
  /// ```dart
  /// 'ababa'.findAllMatches('aba'); // [SearchMatch(index: 0), SearchMatch(index: 2)]
  /// ```
  List<SearchMatch> findAllMatches(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return StringSearch.findAll(
      this,
      pattern,
      algorithm: algorithm,
    );
  }

  /// Returns all match indices (including overlapping matches).
  ///
  /// Example:
  /// ```dart
  /// 'ababa'.findAllMatchIndices('aba'); // [0, 2]
  /// ```
  List<int> findAllMatchIndices(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return StringSearch.findAllIndices(
      this,
      pattern,
      algorithm: algorithm,
    );
  }
}
