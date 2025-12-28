import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Levenshtein', () {
    test('standard comparison', () {
      // distance is 3. len("sitting") is 7. score = 1 - 3/7 = 4/7 ~= 0.57
      expect(
        StringSimilarity.compare('kitten', 'sitting',
            algorithm: SimilarityAlgorithm.levenshtein),
        closeTo(0.57, 0.01),
      );
    });

    test('extension method', () {
      expect(
        'kitten'.similarityTo('sitting',
            algorithm: SimilarityAlgorithm.levenshtein),
        closeTo(0.57, 0.01),
      );
    });

    test('identical strings', () {
      expect(
        'hello'
            .similarityTo('hello', algorithm: SimilarityAlgorithm.levenshtein),
        equals(1.0),
      );
    });

    test('completely different', () {
      // 'abc' vs 'def' distance 3. max len 3. score 0.0
      expect(
        'abc'.similarityTo('def', algorithm: SimilarityAlgorithm.levenshtein),
        equals(0.0),
      );
    });

    test('empty string', () {
      expect(''.similarityTo('a', algorithm: SimilarityAlgorithm.levenshtein),
          equals(0.0));
      expect('a'.similarityTo('', algorithm: SimilarityAlgorithm.levenshtein),
          equals(0.0));
      expect(''.similarityTo('', algorithm: SimilarityAlgorithm.levenshtein),
          equals(1.0));
    });
  });
}
