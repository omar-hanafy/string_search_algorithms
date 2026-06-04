// Empirical calibration for the composite (scaled-max) metric.
//
// The composite metric combines several witness algorithms into one stable
// score. Because each witness lives on a different scale (Jaro-Winkler runs
// "hot", token cosine runs "cold", etc.), we first remap every witness through
// a per-witness *noise floor* before combining:
//
//   scaled = clamp01((raw - floor) / (1 - floor))
//
// This script derives those floors empirically. It samples a large number of
// *unrelated* string pairs (random words drawn from the system dictionary,
// mixed single- and multi-word) and measures each witness's score
// distribution on pure noise. The suggested floor is the 95th percentile of
// that noise distribution: at the default floor, ~95% of unrelated pairs map
// to 0, so only above-noise signal survives.
//
// Re-run with:  dart run benchmark/composite_calibration.dart
// The numbers it prints are baked as defaults in CompositeOptions.
import 'dart:io';
import 'dart:math';

import 'package:string_search_algorithms/string_search_algorithms.dart';

const int _seed = 42;
const int _singleWordPairs = 12000;
const int _twoWordPairs = 5000;
const int _threeWordPairs = 3000;

// Witnesses that make up the default composite recipe.
const Map<String, SimilarityAlgorithm> _witnesses =
    <String, SimilarityAlgorithm>{
  'jaroWinkler': SimilarityAlgorithm.jaroWinkler,
  'dice': SimilarityAlgorithm.diceCoefficient,
  'cosine': SimilarityAlgorithm.cosine,
  'overlap': SimilarityAlgorithm.overlapCoefficient,
};

void main() {
  final words = _loadWords();
  if (words.length < 1000) {
    stderr
        .writeln('Not enough dictionary words to calibrate (${words.length}).');
    exitCode = 1;
    return;
  }
  stdout.writeln('Loaded ${words.length} clean words.\n');

  final rng = Random(_seed);
  final pairs = <List<String>>[
    for (var i = 0; i < _singleWordPairs; i++) _randomPhrase(words, rng, 1, 1),
    for (var i = 0; i < _twoWordPairs; i++) _randomPhrase(words, rng, 2, 2),
    for (var i = 0; i < _threeWordPairs; i++) _randomPhrase(words, rng, 3, 3),
  ];
  stdout.writeln('Scoring ${pairs.length} unrelated pairs across '
      '${_witnesses.length} witnesses...\n');

  final samples = <String, List<double>>{
    for (final name in _witnesses.keys) name: <double>[],
  };

  // Use default normalization/cache, matching the engine the composite runs in.
  final engine = StringSimilarityEngine();
  for (final pair in pairs) {
    for (final entry in _witnesses.entries) {
      samples[entry.key]!
          .add(engine.compare(pair[0], pair[1], algorithm: entry.value));
    }
  }

  stdout.writeln('witness      mean    p50    p90    p95    p99    max   '
      '-> floor (p95)');
  stdout.writeln('-' * 72);
  final suggested = <String, double>{};
  for (final name in _witnesses.keys) {
    final values = samples[name]!..sort();
    final floor = _round2(_percentile(values, 0.95));
    suggested[name] = floor;
    stdout.writeln(
      '${name.padRight(11)} '
      '${_fmt(_mean(values))} '
      '${_fmt(_percentile(values, 0.50))} '
      '${_fmt(_percentile(values, 0.90))} '
      '${_fmt(_percentile(values, 0.95))} '
      '${_fmt(_percentile(values, 0.99))} '
      '${_fmt(values.last)}   '
      '-> $floor',
    );
  }

  stdout.writeln('\nSuggested CompositeOptions floor defaults:');
  suggested.forEach((name, floor) {
    stdout.writeln('  ${name}Floor: $floor');
  });
}

List<String> _loadWords() {
  final file = File('/usr/share/dict/words');
  if (!file.existsSync()) return const <String>[];
  final clean = <String>[];
  final valid = RegExp(r'^[a-z]{3,12}$');
  for (final raw in file.readAsLinesSync()) {
    final w = raw.toLowerCase();
    if (valid.hasMatch(w)) clean.add(w);
  }
  return clean;
}

/// Builds a pair of distinct random phrases each with [minWords]..[maxWords]
/// words. Distinctness keeps us measuring noise, not accidental exact matches.
List<String> _randomPhrase(
    List<String> words, Random rng, int minWords, int maxWords) {
  String phrase() {
    final count = minWords + rng.nextInt(maxWords - minWords + 1);
    return List<String>.generate(
      count,
      (_) => words[rng.nextInt(words.length)],
    ).join(' ');
  }

  var a = phrase();
  var b = phrase();
  // Avoid the degenerate identical case (engine short-circuits it to 1.0).
  var guard = 0;
  while (a == b && guard++ < 5) {
    b = phrase();
  }
  return <String>[a, b];
}

double _mean(List<double> sorted) {
  if (sorted.isEmpty) return 0.0;
  var sum = 0.0;
  for (final v in sorted) {
    sum += v;
  }
  return sum / sorted.length;
}

double _percentile(List<double> sorted, double p) {
  if (sorted.isEmpty) return 0.0;
  final idx = (p * (sorted.length - 1)).round();
  return sorted[idx];
}

double _round2(double v) => (v * 100).roundToDouble() / 100;

String _fmt(double v) => v.toStringAsFixed(3).padLeft(6);
