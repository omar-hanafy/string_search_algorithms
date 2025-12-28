import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Fuzzy Matching', () {
    test('findMatches', () {
      final candidates = ['apple', 'banana', 'orange', 'pear', 'apricot'];
      final matches = StringSimilarity.findMatches('appel', candidates,
          algorithm: SimilarityAlgorithm.diceCoefficient, minScore: 0.5);

      expect(matches.isNotEmpty, isTrue);
      expect(matches.first.value, equals('apple'));
    });

    test('findBestMatch', () {
      final candidates = ['apple', 'banana', 'orange', 'pear', 'apricot'];
      final match = StringSimilarity.findBestMatch('appel', candidates,
          algorithm: SimilarityAlgorithm.diceCoefficient);

      expect(match?.value, equals('apple'));
    });

    test('Extension mostSimilarTo', () {
      final candidates = ['apple', 'banana', 'orange'];
      final match = 'appel'.bestFuzzyMatchIn(candidates,
          algorithm: SimilarityAlgorithm.diceCoefficient);
      expect(match?.value, equals('apple'));
    });
  });
}
