import 'package:string_search_algorithms/src/search/algorithms/search_algorithm.dart';

/// Represents a successful match of a pattern in a text.
class SearchMatch {
  /// Creates a new [SearchMatch].
  const SearchMatch({
    required this.index,
    required this.length,
    required this.algorithm,
  });

  /// The start index of the match in the text.
  final int index;

  /// The length of the match.
  final int length;

  /// The algorithm that found this match.
  final SearchAlgorithm algorithm;

  /// The exclusive end index of the match (index + length).
  int get end => index + length;

  @override
  String toString() =>
      'SearchMatch(index: $index, length: $length, algorithm: $algorithm)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchMatch &&
        other.index == index &&
        other.length == length &&
        other.algorithm == algorithm;
  }

  @override
  int get hashCode => Object.hash(index, length, algorithm);
}
