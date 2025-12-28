import '../../common/typedefs.dart';

class FuzzyMatch<T> {
  const FuzzyMatch({
    required this.value,
    required this.score,
    required this.algorithm,
    this.normalizedValue,
  });

  final T value;
  final SimilarityScore score;
  final SimilarityAlgorithm algorithm;

  /// Normalized candidate value, if requested by the caller.
  final String? normalizedValue;

  /// Compares this match to [other] by score (descending).
  int compareTo(FuzzyMatch<T> other) => other.score.compareTo(score);

  @override
  String toString() =>
      'FuzzyMatch(value: $value, score: ${score.toStringAsFixed(3)})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FuzzyMatch<T> &&
        other.value == value &&
        other.score == score &&
        other.algorithm == algorithm &&
        other.normalizedValue == normalizedValue;
  }

  @override
  int get hashCode => Object.hash(value, score, algorithm, normalizedValue);
}
  