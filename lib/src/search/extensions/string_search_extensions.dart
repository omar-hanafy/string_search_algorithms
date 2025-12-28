import '../algorithms/search_algorithm.dart';
import '../facade.dart';
import '../models/search_match.dart';

/// Convenience extensions for using [StringSearch] on String instances.
///
/// Note: We intentionally avoid names like `indexOf` / `contains` to prevent
/// confusion with built-in String methods.
extension StringSearchExtensions on String {
  /// Finds the first index of [pattern] in this string using the chosen algorithm.
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

  /// Returns true if [pattern] occurs in this string using the chosen algorithm.
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
