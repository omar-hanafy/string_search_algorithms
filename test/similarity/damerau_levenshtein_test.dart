import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Damerau-Levenshtein', () {
    test('transposition', () {
      // Transposition 'ba' -> 'ab' cost 1
      expect(
        StringSimilarity.compare('ba', 'ab', algorithm: SimilarityAlgorithm.damerauLevenshtein),
        equals(0.5), // 1 distance / 2 length = 0.5 similarity
      );
    });

    test('standard edit', () {
      // 'kitten' -> 'sitting' distance 3
      expect(
        StringSimilarity.compare('kitten', 'sitting', algorithm: SimilarityAlgorithm.damerauLevenshtein),
        closeTo(0.57, 0.01),
      );
    });
  });
}
