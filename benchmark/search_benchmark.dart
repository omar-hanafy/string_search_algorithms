import 'package:string_search_algorithms/string_search_algorithms.dart';

void main() {
  print('Running Search Benchmarks...\n');

  final benchmark = SearchBenchmark();
  benchmark.run();
}

class SearchBenchmark {
  final String shortText = 'The quick brown fox jumps over the lazy dog';
  final String shortPattern = 'brown';

  final String longText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' *
          1000; // ~55KB
  final String longPattern = 'consectetur';

  void run() {
    print('--- Short Text (${shortText.length} chars) ---');
    _measure('KMP', SearchAlgorithm.kmp, shortText, shortPattern, 10000);
    _measure('Boyer-Moore', SearchAlgorithm.boyerMoore, shortText, shortPattern,
        10000);
    _measure('Rabin-Karp', SearchAlgorithm.rabinKarp, shortText, shortPattern,
        10000);
    _measure(
        'Standard', SearchAlgorithm.boyerMoore, shortText, shortPattern, 10000);

    print('\n--- Long Text (${longText.length} chars) ---');
    _measure('KMP', SearchAlgorithm.kmp, longText, longPattern, 100);
    _measure(
        'Boyer-Moore', SearchAlgorithm.boyerMoore, longText, longPattern, 100);
    _measure(
        'Rabin-Karp', SearchAlgorithm.rabinKarp, longText, longPattern, 100);
    _measure(
        'Standard', SearchAlgorithm.boyerMoore, longText, longPattern, 100);

    print('\n--- Compiled Pattern Reuse (Short Text) ---');
    _measureCompiled(
        'KMP', SearchAlgorithm.kmp, shortText, shortPattern, 10000);
    _measureCompiled('Boyer-Moore', SearchAlgorithm.boyerMoore, shortText,
        shortPattern, 10000);
  }

  void _measure(
    String name,
    SearchAlgorithm algorithm,
    String text,
    String pattern,
    int iterations,
  ) {
    // Warmup
    StringSearch.indexOf(text, pattern, algorithm: algorithm);

    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      StringSearch.indexOf(text, pattern, algorithm: algorithm);
    }

    stopwatch.stop();
    final totalMicroseconds = stopwatch.elapsedMicroseconds;
    final avgMicroseconds = totalMicroseconds / iterations;

    print('$name: ${avgMicroseconds.toStringAsFixed(2)} µs/op');
  }

  void _measureCompiled(
    String name,
    SearchAlgorithm algorithm,
    String text,
    String patternStr,
    int iterations,
  ) {
    final pattern = StringSearch.compile(patternStr, algorithm: algorithm);

    // Warmup
    pattern.indexOfIn(text);

    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < iterations; i++) {
      pattern.indexOfIn(text);
    }

    stopwatch.stop();
    final totalMicroseconds = stopwatch.elapsedMicroseconds;
    final avgMicroseconds = totalMicroseconds / iterations;

    print('$name (Compiled): ${avgMicroseconds.toStringAsFixed(2)} µs/op');
  }
}
