import 'package:string_search_algorithms/src/common/exceptions.dart';
import 'package:string_search_algorithms/src/search/algorithms/search_algorithm.dart';
import 'package:string_search_algorithms/src/search/models/search_match.dart';

/// Represents a pre-compiled search pattern for efficient reuse.
abstract interface class CompiledPattern {
  /// The pattern string used for searching.
  String get pattern;

  /// The algorithm used by this compiled pattern.
  SearchAlgorithm get algorithm;

  /// Returns the index of the first occurrence of the pattern in [text].
  ///
  /// Returns -1 if not found.
  ///
  /// Throws [InvalidInputException] if [start] is not within
  /// `0 <= start <= text.length`.
  int indexOfIn(String text, {int start = 0});

  /// Returns true if the pattern is found in [text].
  ///
  /// Throws [InvalidInputException] if [start] is not within
  /// `0 <= start <= text.length`.
  bool containsIn(String text, {int start = 0});

  /// Returns all non-overlapping matches of the pattern in [text].
  ///
  /// (Note: Some implementations might allow overlapping matches if specified).
  List<SearchMatch> findAllIn(String text);

  /// Returns the starting indices of all matches in [text].
  List<int> findAllIndicesIn(String text);
}
