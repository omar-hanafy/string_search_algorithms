# Changelog

All notable changes to this package will be documented in this file.

## 1.0.1

### Documentation

- Refresh package description and README introduction copy.
- Update README install snippet for 1.0.1.

## 1.0.0

### Added

- Initial stable release of the similarity and search libraries.
- Instance-based engines with configurable normalization and caching.
- Similarity algorithms: Dice, Levenshtein, Damerau-Levenshtein, OSA, Jaro,
  Jaro-Winkler, Cosine, Jaccard, Overlap, Tversky, N-gram, Hamming, LCS,
  Soundex, Metaphone.
- Substring search algorithms: KMP, Boyer-Moore, Rabin-Karp.
- CompiledPattern for repeated substring searches.
- Convenience String extension methods for similarity and search.
- Benchmark scripts under `benchmark/`.

### Documentation

- Complete API documentation for all public members.
- Updated README with examples and configuration guidance.
