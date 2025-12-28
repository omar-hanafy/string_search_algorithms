import 'package:string_search_algorithms/src/common/typedefs.dart';

/// Result of benchmarking a single [SimilarityAlgorithm].
///
/// Time units are in **microseconds** to match Stopwatch precision used
/// elsewhere.
class BenchmarkResult {
  /// Creates a [BenchmarkResult].
  const BenchmarkResult({
    required this.algorithm,
    required this.averageTime,
    required this.minTime,
    required this.maxTime,
    required this.totalTime,
    required this.iterations,
  });

  /// The algorithm that was benchmarked.
  final SimilarityAlgorithm algorithm;

  /// Average execution time in microseconds.
  final double averageTime;

  /// Minimum execution time in microseconds.
  final int minTime;

  /// Maximum execution time in microseconds.
  final int maxTime;

  /// Total execution time in microseconds.
  final int totalTime;

  /// Number of iterations measured.
  final int iterations;

  /// Returns a formatted string summary of the benchmark results.
  String toReport() => '''
Algorithm: ${algorithm.name}
Iterations: $iterations
Average Time: ${averageTime.toStringAsFixed(2)}µs
Min Time: $minTimeµs
Max Time: $maxTimeµs
Total Time: $totalTimeµs
''';
}
