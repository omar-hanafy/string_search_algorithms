import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/context.dart';

/// Interface for a string similarity or distance metric.
abstract interface class SimilarityMetric {
  /// Unique identifier for this metric (e.g., 'jaro_winkler').
  String get id;

  /// Calculates the similarity score (0.0 to 1.0) for the given context.
  SimilarityScore score(SimilarityContext ctx);
}

/// A score paired with metric-specific detail metadata.
///
/// Returned by [ExplainableMetric.scoreWithDetails]. The [details] map is
/// surfaced on [SimilarityResult.metadata] by
/// [StringSimilarityEngine.compareWithDetails].
typedef ExplainedScore = ({
  SimilarityScore score,
  Map<String, Object?> details,
});

/// Optional capability for metrics that can explain how a score was produced.
///
/// When a metric implements this, [StringSimilarityEngine.compareWithDetails]
/// surfaces the returned [ExplainedScore.details] on
/// [SimilarityResult.metadata]. Metrics that do not implement it simply report
/// an empty metadata map.
abstract interface class ExplainableMetric implements SimilarityMetric {
  /// Calculates the score together with detail metadata explaining it
  /// (for example, per-witness sub-scores for a composite metric).
  ExplainedScore scoreWithDetails(SimilarityContext ctx);
}
