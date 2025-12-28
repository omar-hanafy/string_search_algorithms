import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Jaro-Winkler', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('MARTHA', 'MARHTA',
            algorithm: SimilarityAlgorithm.jaroWinkler),
        closeTo(0.96, 0.01),
      );
    });

    test('extension method', () {
      expect(
        'MARTHA'.similarityTo('MARHTA', algorithm: SimilarityAlgorithm.jaroWinkler),
        closeTo(0.96, 0.01),
      );
    });

    test('identical strings', () {
      expect('abc'.similarityTo('abc', algorithm: SimilarityAlgorithm.jaroWinkler), equals(1.0));
    });
    
    test('prefix boost', () {
      // 'hello world' vs 'hello warld' should have high score due to prefix
      expect(
        'hello world'.similarityTo('hello warld', algorithm: SimilarityAlgorithm.jaroWinkler),
        greaterThan(0.9),
      );
    });
  });
}
