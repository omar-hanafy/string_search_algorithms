import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('LCS', () {
    test('standard comparison', () {
      // ABCDGH vs AEDFHR. LCS is ADH (3). Max len 6. Score 0.5.
      expect(
        StringSimilarity.compare('ABCDGH', 'AEDFHR',
            algorithm: SimilarityAlgorithm.lcs),
        equals(0.5),
      );
    });
  });
}
