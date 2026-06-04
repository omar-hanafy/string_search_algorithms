# String Search Algorithms

Simple Dart library for string similarity and substring search. Pure Dart,
null-safe, with configurable engines and caching for repeated comparisons.

## Highlights

- Similarity metrics: Levenshtein, Jaro-Winkler, Cosine, Jaccard, and more.
- Composite "smart" matching: a calibrated ensemble that stays robust across
  typos, word reordering, and containment - and is safe to rank with.
- Search algorithms: KMP, Boyer-Moore, Rabin-Karp, and a standard wrapper.
- Instance-based engines with configurable normalization and caching.
- Compiled patterns for efficient repeated substring searches.
- Extension methods for ergonomic usage on String.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  string_search_algorithms: ^1.0.1
```

## Quick start

```dart
import 'package:string_search_algorithms/string_search_algorithms.dart';

void main() {
  final score = StringSimilarity.compare(
    'Dwayne',
    'Duane',
    algorithm: SimilarityAlgorithm.jaroWinkler,
  );
  print('Similarity: $score');

  final index = StringSearch.indexOf(
    'The quick brown fox jumps over the lazy dog',
    'brown',
    algorithm: SearchAlgorithm.boyerMoore,
  );
  print('Index: $index');
}
```

## Similarity

### Static helpers

```dart
final score = StringSimilarity.compare(
  'kitten',
  'sitting',
  algorithm: SimilarityAlgorithm.levenshtein,
);

final details = StringSimilarity.compareWithDetails(
  'Dwayne',
  'Duane',
  algorithm: SimilarityAlgorithm.jaroWinkler,
);
```

### Engine with options

Use `StringSimilarityEngine` for per-instance configuration and caching.

```dart
final engine = StringSimilarityEngine(
  options: const SimilarityOptions(
    normalization: NormalizationOptions(
      toLowerCase: true,
      removeAccents: true,
      removeSpecialChars: true,
      trimWhitespace: true,
    ),
    cache: CacheOptions(
      enabled: true,
      normalizedCapacity: 1000,
      bigramCapacity: 1000,
      ngramCapacity: 1000,
    ),
    algorithms: AlgorithmOptions(
      ngramSize: 3,
      tverskyAlpha: 0.5,
      tverskyBeta: 0.5,
      jaroWinklerPrefixScale: 0.1,
      jaroWinklerBoostThreshold: 0.7,
    ),
  ),
);

final score = engine.compare(
  'Cafe!',
  'cafe',
  algorithm: SimilarityAlgorithm.levenshtein,
);
```

### Fuzzy matching

```dart
final candidates = ['apple', 'banana', 'orange', 'grape'];
final matches = StringSimilarity.findMatches(
  'appel',
  candidates,
  minScore: 0.5,
);

for (final match in matches) {
  print('${match.value}: ${match.score}');
}
```

### Composite (smart) similarity

When you do not want to pick a single algorithm, use
`SimilarityAlgorithm.composite`. It combines complementary witnesses
(Jaro-Winkler, Dice, Cosine, Overlap) into one stable score that handles typos,
word reordering, and containment at once. Unlike picking an algorithm per input,
it produces comparable scores, so it is safe to use with `findMatches` and
`rankByRelevance`.

```dart
StringSimilarity.compare(
  'John Smith',
  'Smith John',
  algorithm: SimilarityAlgorithm.composite,
); // high - word reordering handled
```

Token-based witnesses respect normalization, so enable
`NormalizationOptions(removeSpecialChars: true)` when inputs carry punctuation
(for example `'Smith, John'`).

Each witness is calibrated against an empirical noise floor before combining, so
unrelated inputs collapse toward 0. The defaults can be tuned via
`CompositeOptions`, and `compareWithDetails` explains the result:

```dart
final result = StringSimilarity.compareWithDetails(
  'John Smith',
  'Smith John',
  algorithm: SimilarityAlgorithm.composite,
);
print(result.metadata['witnesses']); // per-witness sub-scores
print(result.metadata['dominant']);  // which witness drove the score
```

## Substring search

### Basic search

```dart
final text = 'The quick brown fox jumps over the lazy dog';
final index = StringSearch.indexOf(
  text,
  'brown',
  algorithm: SearchAlgorithm.boyerMoore,
);
```

### Compiled patterns

```dart
final pattern = StringSearch.compile(
  'fox',
  algorithm: SearchAlgorithm.kmp,
);

if (pattern.containsIn(text)) {
  print('Found!');
}

for (final match in pattern.findAllIn(text)) {
  print('Found at ${match.index}');
}
```

## Configuration

- `NormalizationOptions` controls trimming, case folding, accent removal, and
  custom preprocessors/postprocessors.
- `CacheOptions` sizes the normalized string, bigram, and n-gram caches.
- `AlgorithmOptions` tunes Jaro-Winkler, N-gram size, and Tversky parameters.
- `CompositeOptions` tunes the composite combiner, witness weights, and the
  per-witness calibration floors.

See the API docs for full option details.

## Benchmarks

Benchmark scripts live in `benchmark/`:

```bash
dart run benchmark/similarity_benchmark.dart
dart run benchmark/search_benchmark.dart
dart run benchmark/composite_calibration.dart # re-derive composite floors
```

## API reference

API docs will be available on pub.dev:
https://pub.dev/documentation/string_search_algorithms/latest/

## Contributing

Contributions are welcome. Please read `CONTRIBUTING.md` and open a PR.

## License

Licensed under the MIT License. See `LICENSE`.
