import '../common/typedefs.dart';
import 'engine.dart';
import 'metrics/similarity_metric.dart';
import 'models/fuzzy_match.dart';
import 'models/similarity_result.dart';

class StringSimilarity {
  static final StringSimilarityEngine _engine = StringSimilarityEngine();

  static SimilarityScore compare(
    String a,
    String b, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    SimilarityMetric? metric,
  }) {
    return _engine.compare(a, b, algorithm: algorithm, metric: metric);
  }

  static SimilarityResult compareWithDetails(
    String a,
    String b, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
  }) {
    return _engine.compareWithDetails(a, b, algorithm: algorithm);
  }

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
