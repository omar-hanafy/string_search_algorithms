import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('OSA (Optimal String Alignment)', () {
    test('simple transposition', () {
      // Transposition allowed: 'abc' -> 'acb' distance 1
      expect(
        StringSimilarity.compare('abc', 'acb', algorithm: SimilarityAlgorithm.osa),
        closeTo(0.66, 0.01), // 1 distance / 3 len = 0.66 similarity
      );
    });
    
    test('restricted transposition', () {
        // CA -> ABC
        // OSA: 3 operations (insert A, insert B, insert C? No.)
        // C A -> A B C
        // 1. C->A (subst)
        // 2. A->B (subst)
        // 3. insert C
        // distance 3.
        
        // Let's use a known case for OSA vs Damerau difference.
        // String a = "CA";
        // String b = "ABC";
        // Damerau: CA -> AC (1) -> ABC (2) (insert B). Distance 2.
        // OSA: CA -> AC (1). But "AC" was formed by transposition. "ABC" requires inserting B into "AC".
        // OSA does not allow multiple edits on same substring.
        // Actually the classic example is:
        // s1 = "ca", s2 = "abc"
        // Damerau = 2 (ca -> ac -> abc)
        // OSA = 3 (ca -> a -> ab -> abc)
        
        // Normalized score:
        // Max len = 3.
        // Damerau Score = 1 - 2/3 = 0.33
        // OSA Score = 1 - 3/3 = 0.0
        
        expect(
            StringSimilarity.compare('ca', 'abc', algorithm: SimilarityAlgorithm.osa),
            equals(0.0)
        );
        expect(
            StringSimilarity.compare('ca', 'abc', algorithm: SimilarityAlgorithm.damerauLevenshtein),
            closeTo(0.33, 0.01)
        );
    });
  });
}
