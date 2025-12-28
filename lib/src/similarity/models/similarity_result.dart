import '../../common/typedefs.dart';

class SimilarityResult {
  const SimilarityResult({
    required this.score,
    required this.algorithm,
    required this.inputA,
    required this.inputB,
    this.normalizedA,
    this.normalizedB,
    this.metadata = const {},
    this.elapsed,
  });

  final SimilarityScore score;
  final SimilarityAlgorithm algorithm;

  final String inputA;
  final String inputB;

  final String? normalizedA;
  final String? normalizedB;

  final Map<String, Object?> metadata;

  /// Elapsed time for the compareWithDetails call, if measured.
  final Duration? elapsed;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'score': score,
      'algorithm': algorithm.name,
      'inputA': inputA,
      'inputB': inputB,
      'normalizedA': normalizedA,
      'normalizedB': normalizedB,
      'metadata': metadata,
      'elapsedMicroseconds': elapsed?.inMicroseconds,
    };
  }

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('SimilarityResult(')
      ..write('algorithm: ${algorithm.name}, ')
      ..write('score: $score, ')
      ..write('inputA: ${_preview(inputA)}, ')
      ..write('inputB: ${_preview(inputB)}');

    if (normalizedA != null || normalizedB != null) {
      buf
        ..write(', normalizedA: ${_preview(normalizedA)}, ')
        ..write('normalizedB: ${_preview(normalizedB)}');
    }

    if (elapsed != null) {
      buf.write(', elapsed: ${elapsed!.inMicroseconds}µs');
    }

    if (metadata.isNotEmpty) {
      buf.write(', metadata: $metadata');
    }

    buf.write(')');
    return buf.toString();
  }

  static String _preview(String? s, {int max = 48}) {
    if (s == null) return 'null';
    if (s.length <= max) return s;
    return '${s.substring(0, max)}…';
  }
}
