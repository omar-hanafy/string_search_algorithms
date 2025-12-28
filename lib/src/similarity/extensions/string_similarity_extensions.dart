import '../../common/typedefs.dart';
import '../facade.dart';
import '../models/fuzzy_match.dart';
import '../models/similarity_result.dart';

/// Convenience extensions for using [StringSimilarity] on String instances.
extension StringSimilarityExtensions on String {
  /// Similarity score between this string and [other].
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

  /// Ranks candidates by similarity (descending), optionally filtered by [minScore].
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
