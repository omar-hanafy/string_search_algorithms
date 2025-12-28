import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Jaro', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('MARTHA', 'MARHTA',
            algorithm: SimilarityAlgorithm.jaro),
        closeTo(0.94, 0.01),
      );
    });

    test('extension method', () {
      expect(
        'MARTHA'.similarityTo('MARHTA', algorithm: SimilarityAlgorithm.jaro),
        closeTo(0.94, 0.01),
      );
    });

    test('identical strings', () {
      expect('abc'.similarityTo('abc', algorithm: SimilarityAlgorithm.jaro),
          equals(1.0));
    });
  });
}
