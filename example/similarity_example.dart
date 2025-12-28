import 'package:string_search_algorithms/similarity.dart';

void main() {
  print('--- String Similarity Example ---');

  // 1. Simple static usage
  final score = StringSimilarity.compare(
    'Dwayne',
    'Duane',
    algorithm: SimilarityAlgorithm.jaroWinkler,
  );
  print('Jaro-Winkler("Dwayne", "Duane"): $score');

  // 2. Extension methods
  print('Dice Coefficient("night", "nacht"): ${'night'.similarityTo('nacht', algorithm: SimilarityAlgorithm.diceCoefficient)}');
  print('Levenshtein("kitten", "sitting"): ${'kitten'.similarityTo('sitting', algorithm: SimilarityAlgorithm.levenshtein)}');

  // 3. Custom Engine with options
  final engine = StringSimilarityEngine(
    options: const SimilarityOptions(
      normalization: NormalizationOptions(
        toLowerCase: true,
        removeAccents: true, // Handle Café -> cafe
        removeSpecialChars: true,
      ),
      cache: CacheOptions(enabled: true, normalizedCapacity: 100),
    ),
  );

  final customScore = engine.compare(
    'Café!',
    'cafe',
    algorithm: SimilarityAlgorithm.levenshtein,
  );
  print('Custom Engine Levenshtein("Café!", "cafe"): $customScore');

  // 4. Fuzzy Matching from a list
  final candidates = ['apple', 'banana', 'orange', 'grape', 'apricot'];
  print('\nSearching for "appel" in candidates: $candidates');
  
  final matches = engine.findMatches(
    'appel',
    candidates,
    algorithm: SimilarityAlgorithm.diceCoefficient,
    minScore: 0.3,
  );

  for (final match in matches) {
    print('Found: ${match.value} (Score: ${match.score.toStringAsFixed(3)})');
  }
}
