import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/context.dart';

/// Interface for a string similarity or distance metric.
abstract interface class SimilarityMetric {
  /// Unique identifier for this metric (e.g., 'jaro_winkler').
  String get id;

  /// Calculates the similarity score (0.0 to 1.0) for the given context.
  SimilarityScore score(SimilarityContext ctx);
}
