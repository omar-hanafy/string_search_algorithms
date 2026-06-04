import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  final engine = StringSimilarityEngine();

  double composite(String a, String b) =>
      engine.compare(a, b, algorithm: SimilarityAlgorithm.composite);

  group('Composite metric - core behavior', () {
    test('identical inputs score 1.0', () {
      expect(composite('apple', 'apple'), 1.0);
    });

    test('empty inputs follow the global invariant', () {
      expect(composite('', ''), 1.0);
      expect(composite('apple', ''), 0.0);
      expect(composite('', 'apple'), 0.0);
    });

    test('handles word reordering (cosine witness)', () {
      final score = composite('john smith', 'smith john');
      final jaroOnly = engine.compare('john smith', 'smith john',
          algorithm: SimilarityAlgorithm.jaroWinkler);

      expect(score, greaterThan(0.9));
      // The whole point: the ensemble beats the single default on reordering.
      expect(score, greaterThan(jaroOnly));
    });

    test('handles single-word typos', () {
      expect(composite('kitten', 'mitten'), greaterThan(0.7));
      expect(composite('recieve', 'receive'), greaterThan(0.8));
    });

    test('handles containment / length disparity (overlap witness)', () {
      expect(composite('apple', 'apple pie'), greaterThan(0.8));
    });

    test('suppresses unrelated inputs via calibration', () {
      // Unrelated pairs fall below every witness floor and collapse to ~0.
      expect(composite('apple', 'zebra'), lessThan(0.3));
    });

    test('very short inputs do not produce spurious matches', () {
      // 'ab' vs 'ac': no shared bigram/token; must not return a high score
      // (guards against the empty-gram 1.0 artifact of set metrics).
      expect(composite('ab', 'ac'), lessThan(0.5));
      // Single different chars: only Jaro-Winkler/cosine apply, both 0.
      expect(composite('a', 'b'), 0.0);
    });

    test('score is monotonic as more characters match (no cliffs)', () {
      // The old shape-switch caused score jumps when input shape crossed a
      // threshold. The ensemble varies smoothly: more matches, higher score.
      double c(String b) =>
          engine.compare('apple', b, algorithm: SimilarityAlgorithm.composite);
      final chain = ['xxxxx', 'axxxx', 'apxxx', 'appxx', 'applx', 'apple'];
      var previous = -1.0;
      for (final candidate in chain) {
        final score = c(candidate);
        expect(score, greaterThanOrEqualTo(previous),
            reason: 'score dropped at "$candidate"');
        previous = score;
      }
      expect(c('apple'), 1.0);
    });
  });

  group('Composite metric - API surfaces', () {
    test('facade and engine agree for composite', () {
      expect(
        StringSimilarity.compare('kitten', 'mitten',
            algorithm: SimilarityAlgorithm.composite),
        closeTo(composite('kitten', 'mitten'), 1e-9),
      );
    });

    test('extension methods support composite', () {
      expect(
        'kitten'
            .similarityTo('mitten', algorithm: SimilarityAlgorithm.composite),
        greaterThan(0.7),
      );

      final details = 'john smith'.similarityDetails('smith john',
          algorithm: SimilarityAlgorithm.composite);
      expect(details.algorithm, SimilarityAlgorithm.composite);
      expect(details.metadata, isNotEmpty);
    });

    test('findBestMatch works with composite', () {
      final best = StringSimilarity.findBestMatch(
        'john smith',
        ['michael jordan', 'smith john', 'random text'],
        algorithm: SimilarityAlgorithm.composite,
      );
      expect(best?.value, 'smith john');
    });

    test('produces comparable scores for ranking', () {
      final ranked = engine.rankByRelevance(
        'john smith',
        ['michael jordan', 'smith john', 'jon smith', 'john smith jr'],
        algorithm: SimilarityAlgorithm.composite,
      );

      // The unrelated candidate must rank last; related ones float to the top.
      expect(ranked.last.value, 'michael jordan');
      expect(ranked.first.value, isNot('michael jordan'));
      expect(ranked.last.score, lessThan(ranked.first.score));
    });
  });

  group('Composite combiner options', () {
    test('scaledMax suppresses noise that raw max would keep', () {
      final scaledMax = StringSimilarityEngine();
      final rawMax = StringSimilarityEngine(
        options: const SimilarityOptions(
          algorithms: AlgorithmOptions(
            composite: CompositeOptions(combiner: CompositeCombiner.max),
          ),
        ),
      );

      // 'apple' vs 'apricot' share a prefix: Jaro-Winkler raw sits just below
      // the noise floor, so calibration zeroes it while raw max keeps it.
      final calibrated = scaledMax.compare('apple', 'apricot',
          algorithm: SimilarityAlgorithm.composite);
      final uncalibrated = rawMax.compare('apple', 'apricot',
          algorithm: SimilarityAlgorithm.composite);

      expect(uncalibrated, greaterThan(0.3)); // there is signal to suppress
      expect(calibrated, lessThan(0.2)); // calibration suppresses the noise
      expect(calibrated, lessThan(uncalibrated));
    });

    test('weightedMean dilutes a single strong witness vs scaledMax', () {
      final weightedMean = StringSimilarityEngine(
        options: const SimilarityOptions(
          algorithms: AlgorithmOptions(
            composite:
                CompositeOptions(combiner: CompositeCombiner.weightedMean),
          ),
        ),
      );

      final scaledMaxScore = composite('john smith', 'smith john');
      final meanScore = weightedMean.compare('john smith', 'smith john',
          algorithm: SimilarityAlgorithm.composite);

      expect(meanScore, greaterThan(0.0));
      expect(meanScore, lessThan(scaledMaxScore));
    });

    test('witness weights influence the score', () {
      final noCosine = StringSimilarityEngine(
        options: const SimilarityOptions(
          algorithms: AlgorithmOptions(
            composite: CompositeOptions(cosineWeight: 0.0),
          ),
        ),
      );

      // Cosine is the witness that catches reordering; zeroing its weight
      // lowers the composite score for a reordered pair.
      expect(
        noCosine.compare('john smith', 'smith john',
            algorithm: SimilarityAlgorithm.composite),
        lessThan(composite('john smith', 'smith john')),
      );
    });

    test('invalid floor throws InvalidConfigurationException', () {
      expect(
        () => StringSimilarityEngine(
          options: const SimilarityOptions(
            algorithms: AlgorithmOptions(
              composite: CompositeOptions(jaroWinklerFloor: 1.5),
            ),
          ),
        ),
        throwsA(isA<InvalidConfigurationException>()),
      );
    });

    test('negative witness weight throws InvalidConfigurationException', () {
      expect(
        () => StringSimilarityEngine(
          options: const SimilarityOptions(
            algorithms: AlgorithmOptions(
              composite: CompositeOptions(cosineWeight: -1.0),
            ),
          ),
        ),
        throwsA(isA<InvalidConfigurationException>()),
      );
    });

    test('CompositeOptions.copyWith overrides only provided fields', () {
      const base = CompositeOptions();
      final updated = base.copyWith(
        combiner: CompositeCombiner.max,
        diceWeight: 0.5,
      );

      expect(updated.combiner, CompositeCombiner.max);
      expect(updated.diceWeight, 0.5);
      expect(updated.cosineWeight, base.cosineWeight); // unchanged
      expect(updated.jaroWinklerFloor, base.jaroWinklerFloor); // unchanged
    });
  });

  group('Composite explainability', () {
    test('compareWithDetails surfaces witness breakdown', () {
      final result = engine.compareWithDetails(
        'john smith',
        'smith john',
        algorithm: SimilarityAlgorithm.composite,
      );

      expect(result.metadata, isNotEmpty);
      expect(result.metadata['combiner'], 'scaledMax');
      expect(result.metadata['dominant'], isNotNull);

      final witnesses = result.metadata['witnesses'] as Map<String, Object?>;
      expect(witnesses.keys, contains('jaroWinkler'));
      expect(witnesses.keys, contains('cosine'));
    });

    test('compareWithDetails short-circuits identical inputs', () {
      final result = engine.compareWithDetails(
        'abc',
        'abc',
        algorithm: SimilarityAlgorithm.composite,
      );

      expect(result.score, 1.0);
      expect(result.metadata, isEmpty);
    });

    test('non-explainable metrics still report empty metadata', () {
      final result = engine.compareWithDetails(
        'kitten',
        'sitting',
        algorithm: SimilarityAlgorithm.jaroWinkler,
      );

      expect(result.metadata, isEmpty);
    });
  });
}
