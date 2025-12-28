import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('Tversky Index', () {
    test('matches ngram when alpha=1, beta=1', () {
      // Tversky with alpha=1, beta=1 is equivalent to Jaccard (Ngram)
      final options = const SimilarityOptions(
        algorithms: AlgorithmOptions(tverskyAlpha: 1.0, tverskyBeta: 1.0),
      );

      final engine = StringSimilarityEngine(options: options);
      final tverskyScore = engine.compare(
        'test',
        'testing',
        algorithm: SimilarityAlgorithm.tversky,
      );
      final ngramScore = StringSimilarity.compare(
        'test',
        'testing',
        algorithm: SimilarityAlgorithm.ngram,
      );

      expect(tverskyScore, closeTo(0.4, 0.01));
      expect(tverskyScore, equals(ngramScore));
    });

    test('asymmetric', () {
      // alpha=2, beta=0.5
      // Emphasis on elements in A not in B.
      // A='test', B='testing'. A-B is empty (A is subset).
      // intersection = 2. diff1(A-B) = 0. diff2(B-A) = 3.
      // denom = 2 + 2*0 + 0.5*3 = 3.5.
      // score = 2 / 3.5 = 0.57.

      final engine = StringSimilarityEngine(
          options: const SimilarityOptions(
              algorithms:
                  AlgorithmOptions(tverskyAlpha: 2.0, tverskyBeta: 0.5)));

      expect(
          engine.compare('test', 'testing',
              algorithm: SimilarityAlgorithm.tversky),
          closeTo(0.57, 0.01));
    });
  });
}
