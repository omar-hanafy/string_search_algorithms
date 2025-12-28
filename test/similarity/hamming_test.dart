import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Hamming', () {
    test('standard comparison', () {
      // 1011 vs 1001. 1 diff. Length 4. Score 0.75.
      expect(
        StringSimilarity.compare('1011', '1001',
            algorithm: SimilarityAlgorithm.hamming),
        equals(0.75),
      );
    });

    test('extension method', () {
      expect(
        '1011'.similarityTo('1001', algorithm: SimilarityAlgorithm.hamming),
        equals(0.75),
      );
    });

    test('different lengths', () {
       // Implementation note: Hamming usually undefined for different lengths.
       // The engine returns max distance (normalized to 0.0 similarity usually).
       // In our implementation, it returns s1.length (max distance).
       // Wait, the engine normalizes: score = 1.0 - (score / maxLength).
       // If score is s1.length, and maxLength is s1.length (if s1>=s2), result is 0.
       expect(
         'abc'.similarityTo('abcd', algorithm: SimilarityAlgorithm.hamming),
         equals(0.0),
       );
    });
  });
}
