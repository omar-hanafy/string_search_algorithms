import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  group('StringSimilarityEngine (Instance)', () {
    test('Custom configuration (Normalization)', () {
      final engine = StringSimilarityEngine(
        options: const SimilarityOptions(
          normalization: NormalizationOptions(
            toLowerCase: false, // Case sensitive
          ),
        ),
      );

      // 'Test' vs 'test'.
      // Dice: 'Te', 'es', 'st' vs 'te', 'es', 'st'.
      // Common: 'es', 'st'. (2). Total: 3+3=6. 2*2/6 = 0.66.
      // If case insensitive (default): 1.0.
      expect(
        engine.compare('Test', 'test',
            algorithm: SimilarityAlgorithm.diceCoefficient),
        lessThan(1.0),
      );
    });

    test('Caching', () {
      // Just verify it doesn't crash
      final engine = StringSimilarityEngine(
        options: const SimilarityOptions(
          cache: CacheOptions(enabled: true, normalizedCapacity: 10),
        ),
      );

      expect(engine.compare('abc', 'abd'), greaterThan(0));
      expect(engine.compare('abc', 'abd'), greaterThan(0)); // Should hit cache
    });
  });
}
