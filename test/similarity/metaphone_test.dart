import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Metaphone', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('Philip', 'Phillip',
            algorithm: SimilarityAlgorithm.metaphone),
        equals(1.0),
      );
    });

    test('extension method', () {
      expect(
        'Philip'
            .similarityTo('Phillip', algorithm: SimilarityAlgorithm.metaphone),
        equals(1.0),
      );
    });
  });
}
