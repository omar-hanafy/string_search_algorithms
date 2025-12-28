import '../algorithms/search_algorithm.dart';

class SearchMatch {
  const SearchMatch({
    required this.index,
    required this.length,
    required this.algorithm,
  });

  final int index;
  final int length;
  final SearchAlgorithm algorithm;

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
