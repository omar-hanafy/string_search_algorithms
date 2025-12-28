import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Soundex', () {
    test('standard comparison', () {
      expect(
        StringSimilarity.compare('Robert', 'Rupert',
            algorithm: SimilarityAlgorithm.soundex),
        equals(1.0),
      );
    });

    test('extension method', () {
      expect(
        'Robert'.similarityTo('Rupert', algorithm: SimilarityAlgorithm.soundex),
        equals(1.0),
      );
    });
    
    test('non-matching', () {
        expect('Robert'.similarityTo('Alice', algorithm: SimilarityAlgorithm.soundex), equals(0.0));
    });
  });
}
