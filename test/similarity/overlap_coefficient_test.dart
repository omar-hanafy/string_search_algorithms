import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Overlap Coefficient', () {
    for (final ngramSize in [3, 5]) {
      test('unequal strings shorter than $ngramSize do not match', () {
        final engine = StringSimilarityEngine(
          options: SimilarityOptions(
            algorithms: AlgorithmOptions(ngramSize: ngramSize),
          ),
        );

        expect(
          engine.compare(
            'ab',
            'xy',
            algorithm: SimilarityAlgorithm.overlapCoefficient,
          ),
          0.0,
        );
        expect(
          engine.compare(
            ' AB ',
            'ab',
            algorithm: SimilarityAlgorithm.overlapCoefficient,
          ),
          1.0,
        );
        expect(
          engine
              .findMatches(
                'ab',
                ['xy', 'ab'],
                algorithm: SimilarityAlgorithm.overlapCoefficient,
                minScore: 1.0,
              )
              .map((match) => match.value),
          ['ab'],
        );
      });
    }

    test('subset', () {
      // 'test' (ngrams: te, es, st) -> 3 ngrams
      // 'testing' (ngrams: te, es, st, ti, in, ng) -> 6 ngrams
      // Intersection: 3. Min size: 3.
      // Overlap: 3/3 = 1.0.
      expect(
        StringSimilarity.compare(
          'test',
          'testing',
          algorithm: SimilarityAlgorithm.overlapCoefficient,
        ),
        equals(1.0),
      );
    });

    test('disjoint', () {
      expect(
        StringSimilarity.compare(
          'abc',
          'xyz',
          algorithm: SimilarityAlgorithm.overlapCoefficient,
        ),
        equals(0.0),
      );
    });
  });
}
