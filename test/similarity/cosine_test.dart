import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Cosine', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('this is a test', 'this is another test',
            algorithm: SimilarityAlgorithm.cosine),
        closeTo(0.75, 0.01),
      );
    });

    test('extension method', () {
      expect(
        'this is a test'.similarityTo('this is another test',
            algorithm: SimilarityAlgorithm.cosine),
        closeTo(0.75, 0.01),
      );
    });

    test('identical strings', () {
      expect(
          'a b c'.similarityTo('a b c', algorithm: SimilarityAlgorithm.cosine),
          equals(1.0));
    });

    test('disjoint strings', () {
      expect('a b'.similarityTo('c d', algorithm: SimilarityAlgorithm.cosine),
          equals(0.0));
    });
  });
}
