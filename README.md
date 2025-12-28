# String Search Algorithms

A production-grade Dart library for efficient string similarity comparisons and substring searching. 

This package provides a robust set of algorithms for:
- **String Similarity**: Fuzzy matching, typo tolerance, and similarity scoring (Levenshtein, Jaro-Winkler, Cosine, etc.).
- **Substring Search**: High-performance pattern finding (KMP, Boyer-Moore, Rabin-Karp).

Designed for performance and flexibility with instance-based engines, extensive caching, and configurable normalization.

## Features

### 🧩 Similarity Algorithms
- **Edit Distance**: Levenshtein, Damerau-Levenshtein, OSA, Hamming, Longest Common Subsequence (LCS).
- **Phonetic**: Soundex, Metaphone.
- **Token-based**: Cosine, Jaccard, Dice Coefficient, Overlap Coefficient, Tversky Index.
- **Character-based**: Jaro, Jaro-Winkler, N-gram.

### 🔍 Search Algorithms
- **Knuth-Morris-Pratt (KMP)**: Optimized for avoiding redundant comparisons.
- **Boyer-Moore**: Fast skipping using the Bad Character rule.
- **Rabin-Karp**: Rolling hash approach.
- **Standard**: Wrapper around Dart's native optimized search.

### 🚀 Key Capabilities
- **Instance-based Engines**: Create isolated engines with their own configuration and caches.
- **Caching**: Smart caching of normalized strings, bigrams, and tokens for high performance.
- **Normalization**: Configurable case sensitivity, accent removal, and whitespace handling.
- **Compiled Patterns**: Pre-compile search patterns for repeated use.

## Usage

### 1. String Similarity

#### Simple Static Usage
Use the `StringSimilarity` facade for quick comparisons using default settings.

```dart
import 'package:string_search_algorithms/string_search_algorithms.dart';

void main() {
  // Compare two strings
  final score = StringSimilarity.compare('Dwayne', 'Duane', algorithm: SimilarityAlgorithm.jaroWinkler);
  print('Similarity: $score'); // ~0.96

  // Extension methods
  print('night'.diceCoefficient('nacht')); // ~0.25
  print('kitten'.levenshtein('sitting'));  // ~0.57 (normalized)
}
```

#### Advanced Usage (Custom Engine)
For heavy workloads or custom configuration, create a `StringSimilarityEngine`.

```dart
final engine = StringSimilarityEngine(
  options: const SimilarityOptions(
    normalization: NormalizationOptions(
      toLowerCase: true,
      removeAccents: true,
      removeSpecialChars: true,
    ),
    cache: CacheOptions(enabled: true, capacity: 1000),
  ),
);

final score = engine.compare('Café!', 'cafe', algorithm: SimilarityAlgorithm.levenshteinDistance);
```

#### Fuzzy Matching
Find the best matches from a list of candidates.

```dart
final candidates = ['apple', 'banana', 'orange', 'grape'];
final matches = StringSimilarity.findMatches('appel', candidates, minScore: 0.5);

for (final match in matches) {
  print('${match.value}: ${match.score}');
}
```

### 2. Substring Search

#### Basic Search
```dart
import 'package:string_search_algorithms/string_search_algorithms.dart';

final text = 'The quick brown fox jumps over the lazy dog';
final index = StringSearch.indexOf(text, 'brown', algorithm: SearchAlgorithm.boyerMoore);
```

#### Compiled Patterns
Compile a pattern once and reuse it for searching multiple texts efficiently.

```dart
final pattern = StringSearch.compile('fox', algorithm: SearchAlgorithm.kmp);

if (pattern.containsIn(text)) {
  print('Found!');
}

final matches = pattern.findAllIn(text);
matches.forEach((m) => print('Found at ${m.index}'));
```

## Algorithms Reference

| Algorithm | Type | Best For |
|-----------|------|----------|
| **Jaro-Winkler** | Similarity | Short strings, names, typos. |
| **Levenshtein** | Distance | General purpose edit distance. |
| **Damerau-Levenshtein** | Distance | Edit distance with transpositions (true distance). |
| **OSA** | Distance | Edit distance with transpositions (restricted). |
| **Dice Coefficient** | Similarity | Bigram similarity, robust to scrambled letters. |
| **Cosine** | Token-based | Multi-word text, document similarity. |
| **Tversky Index** | Token-based | Asymmetric set similarity (flexible Jaccard). |
| **Soundex** | Phonetic | English names (phonetic grouping). |
| **Metaphone** | Phonetic | More accurate English phonetic matching. |
| **KMP** | Search | Linear time search, avoiding backtracking. |
| **Boyer-Moore** | Search | Fast searching in long texts/large alphabets. |

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  string_search_algorithms: ^0.1.0
```

## Contributing

Contributions are welcome! Please check the issues and feel free to submit Pull Requests.