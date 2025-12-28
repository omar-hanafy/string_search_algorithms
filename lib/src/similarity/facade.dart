import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/engine.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';
import 'package:string_search_algorithms/src/similarity/models/fuzzy_match.dart';
import 'package:string_search_algorithms/src/similarity/models/similarity_result.dart';

/// Static facade for common string similarity operations.
///
/// Use [StringSimilarityEngine] for instance-based usage, caching, and custom
/// configuration.
class StringSimilarity {
  static final StringSimilarityEngine _engine = StringSimilarityEngine();

  /// Calculates the similarity score (0.0 to 1.0) between [a] and [b].
  ///
  /// Example:
  /// ```dart
  /// StringSimilarity.compare('kitten', 'sitting'); // 0.746...
  /// ```
  static SimilarityScore compare(
    String a,
    String b, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    SimilarityMetric? metric,
  }) {
    return _engine.compare(a, b, algorithm: algorithm, metric: metric);
  }

  /// Calculates similarity with detailed metadata.
  ///
  /// Example:
  /// ```dart
  /// final result = StringSimilarity.compareWithDetails('kitten', 'sitting');
  /// print(result.score); // 0.746...
  /// ```
  static SimilarityResult compareWithDetails(
    String a,
    String b, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
  }) {
    return _engine.compareWithDetails(a, b, algorithm: algorithm);
  }

  /// Finds matches for [query] in [candidates] with a score >= [minScore].
  ///
  /// Example:
  /// ```dart
  /// StringSimilarity.findMatches(
  ///   'apple',
  ///   ['aple', 'pear', 'app'],
  ///   minScore: 0.8,
  /// );
  /// ```
  static List<FuzzyMatch<String>> findMatches(
    String query,
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    int? topK,
    bool sort = true,
    bool includeNormalized = false,
  }) {
    return _engine.findMatches(
      query,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      topK: topK,
      sort: sort,
      includeNormalized: includeNormalized,
    );
  }

  /// Finds the best match for [query] in [candidates].
  ///
  /// Example:
  /// ```dart
  /// StringSimilarity.findBestMatch(
  ///   'apple',
  ///   ['aple', 'pear'],
  /// ); // FuzzyMatch('aple')
  /// ```
  static FuzzyMatch<String>? findBestMatch(
    String query,
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    bool includeNormalized = false,
  }) {
    return _engine.findBestMatch(
      query,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      includeNormalized: includeNormalized,
    );
  }

  /// Ranks [candidates] by similarity to [query].
  ///
  /// Example:
  /// ```dart
  /// StringSimilarity.rankByRelevance('apple', ['pear', 'aple', 'app']);
  /// // [FuzzyMatch('aple'), FuzzyMatch('app'), FuzzyMatch('pear')]
  /// ```
  static List<FuzzyMatch<String>> rankByRelevance(
    String query,
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    bool includeNormalized = false,
  }) {
    return _engine.rankByRelevance(
      query,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      includeNormalized: includeNormalized,
    );
  }
}
