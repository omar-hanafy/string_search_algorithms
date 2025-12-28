import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/facade.dart';
import 'package:string_search_algorithms/src/similarity/models/fuzzy_match.dart';
import 'package:string_search_algorithms/src/similarity/models/similarity_result.dart';

/// Convenience extensions for using [StringSimilarity] on String instances.
extension StringSimilarityExtensions on String {
  /// Similarity score between this string and [other].
  ///
  /// Example:
  /// ```dart
  /// 'kitten'.similarityTo('sitting'); // 0.746...
  /// ```
  SimilarityScore similarityTo(
    String other, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
  }) {
    return StringSimilarity.compare(
      this,
      other,
      algorithm: algorithm,
    );
  }

  /// Similarity comparison with detailed output.
  ///
  /// Example:
  /// ```dart
  /// final result = 'kitten'.similarityDetails('sitting');
  /// print(result.score); // 0.746...
  /// print(result.normalizedA); // kitten
  /// ```
  SimilarityResult similarityDetails(
    String other, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
  }) {
    return StringSimilarity.compareWithDetails(
      this,
      other,
      algorithm: algorithm,
    );
  }

  /// Finds candidates with similarity >= [minScore].
  ///
  /// Example:
  /// ```dart
  /// 'apple'.fuzzyMatchesIn(['aple', 'pear', 'app'], minScore: 0.8);
  /// ```
  List<FuzzyMatch<String>> fuzzyMatchesIn(
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    int? topK,
    bool sort = true,
    bool includeNormalized = false,
  }) {
    return StringSimilarity.findMatches(
      this,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      topK: topK,
      sort: sort,
      includeNormalized: includeNormalized,
    );
  }

  /// Finds the best fuzzy match (or null if none meets [minScore]).
  ///
  /// Example:
  /// ```dart
  /// 'apple'.bestFuzzyMatchIn(['aple', 'pear']); // FuzzyMatch(value: 'aple', ...)
  /// ```
  FuzzyMatch<String>? bestFuzzyMatchIn(
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    bool includeNormalized = false,
  }) {
    return StringSimilarity.findBestMatch(
      this,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      includeNormalized: includeNormalized,
    );
  }

  /// Ranks candidates by similarity (descending), optionally filtered by
  /// [minScore].
  ///
  /// Example:
  /// ```dart
  /// 'apple'.rankFuzzyMatchesIn(['pear', 'aple', 'app']);
  /// // [FuzzyMatch('aple'), FuzzyMatch('app'), FuzzyMatch('pear')]
  /// ```
  List<FuzzyMatch<String>> rankFuzzyMatchesIn(
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    bool includeNormalized = false,
  }) {
    return StringSimilarity.rankByRelevance(
      this,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      includeNormalized: includeNormalized,
    );
  }
}
