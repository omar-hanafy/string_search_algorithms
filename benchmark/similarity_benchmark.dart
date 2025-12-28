import 'package:string_search_algorithms/string_search_algorithms.dart';

void main() {
  print('Running Similarity Benchmarks...\n');

  final benchmark = SimilarityBenchmark();
  benchmark.run();
}

class SimilarityBenchmark {
  final List<List<String>> shortPairs = [
    ['kitten', 'sitting'],
    ['Sunday', 'Saturday'],
    ['dwayne', 'duane'],
    ['martha', 'marhta'],
    ['abc', 'abc'],
  ];

  final List<List<String>> longPairs = [
    [
      'The quick brown fox jumps over the lazy dog',
      'The quick brown fox jumps over the lazy cat'
    ],
    [
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    ],
  ];

  void run() {
    _measure('Dice Coefficient (Short)', SimilarityAlgorithm.diceCoefficient,
        shortPairs, 10000);
    _measure('Dice Coefficient (Long)', SimilarityAlgorithm.diceCoefficient,
        longPairs, 10000);

    print('');

    _measure('Levenshtein (Short)', SimilarityAlgorithm.levenshtein, shortPairs,
        10000);
    _measure('Levenshtein (Long)', SimilarityAlgorithm.levenshtein, longPairs,
        1000); // Expensive

    print('');

    _measure('Jaro-Winkler (Short)', SimilarityAlgorithm.jaroWinkler,
        shortPairs, 10000);
    _measure('Jaro-Winkler (Long)', SimilarityAlgorithm.jaroWinkler, longPairs,
        10000);

    print('');

    _measure('Cosine (Short)', SimilarityAlgorithm.cosine, shortPairs, 10000);
    _measure('Cosine (Long)', SimilarityAlgorithm.cosine, longPairs, 10000);
  }

  void _measure(
    String name,
    SimilarityAlgorithm algorithm,
    List<List<String>> pairs,
    int iterations,
  ) {
    // Warmup
    for (final pair in pairs) {
      StringSimilarity.compare(pair[0], pair[1], algorithm: algorithm);
    }

    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      for (final pair in pairs) {
        StringSimilarity.compare(pair[0], pair[1], algorithm: algorithm);
      }
    }

    stopwatch.stop();
    final totalMicroseconds = stopwatch.elapsedMicroseconds;
    final avgMicroseconds = totalMicroseconds / (iterations * pairs.length);

    print('$name: ${avgMicroseconds.toStringAsFixed(2)} µs/op');
  }
}
