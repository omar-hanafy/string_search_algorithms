import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Ngram', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('hello', 'hallo',
            algorithm: SimilarityAlgorithm.ngram),
        greaterThan(0.0),
      );
    });

    test('extension method', () {
      expect(
        'hello'.similarityTo('hallo', algorithm: SimilarityAlgorithm.ngram),
        greaterThan(0.0),
      );
    });
  });
}
