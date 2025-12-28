import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Jaccard', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('cat dog', 'dog cat',
            algorithm: SimilarityAlgorithm.jaccard),
        equals(1.0),
      );
    });

    test('extension method', () {
      expect(
        'cat dog'.similarityTo('dog cat', algorithm: SimilarityAlgorithm.jaccard),
        equals(1.0),
      );
    });

    test('partial overlap', () {
      // A = {a, b, c}, B = {b, c, d}
      // Intersection = {b, c} (2)
      // Union = {a, b, c, d} (4)
      // Score = 0.5
      expect(
        'a b c'.similarityTo('b c d', algorithm: SimilarityAlgorithm.jaccard),
        equals(0.5),
      );
    });
  });
}
