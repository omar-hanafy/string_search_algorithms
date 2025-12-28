import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Dice Coefficient', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('night', 'nacht',
            algorithm: SimilarityAlgorithm.diceCoefficient),
        closeTo(0.25, 0.01),
      );
    });

    test('extension method', () {
      expect(
        'night'.similarityTo('nacht', algorithm: SimilarityAlgorithm.diceCoefficient),
        closeTo(0.25, 0.01),
      );
    });

    test('identical strings', () {
      expect(
        'hello'.similarityTo('hello', algorithm: SimilarityAlgorithm.diceCoefficient),
        equals(1.0),
      );
    });

    test('completely different', () {
      expect(
        'abc'.similarityTo('xyz', algorithm: SimilarityAlgorithm.diceCoefficient),
        equals(0.0),
      );
    });
  });
}
