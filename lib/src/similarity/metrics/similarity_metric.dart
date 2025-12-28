import '../../common/typedefs.dart';
import '../context.dart';

abstract interface class SimilarityMetric {
  String get id;
  SimilarityScore score(SimilarityContext ctx);
}
