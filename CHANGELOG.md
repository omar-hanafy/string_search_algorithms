# Changelog

All notable changes to this package will be documented in this file.

## 1.1.0

### Added

- `SimilarityAlgorithm.composite`: a calibrated ensemble metric that combines
  Jaro-Winkler, Dice, Cosine, and Overlap witnesses into one stable score.
  Robust across typos, word reordering, and containment, and safe to use in
  `findMatches` / `rankByRelevance` because every pair is scored comparably.
- `CompositeOptions` and `CompositeCombiner` to configure the combiner
  (`scaledMax`, `weightedMean`, `max`), witness weights, and the per-witness
  calibration floors (defaults derived empirically; see
  `benchmark/composite_calibration.dart`).
- `ExplainableMetric` interface and `ExplainedScore`: metrics can now explain a
  score. `compareWithDetails` populates `SimilarityResult.metadata` with the
  composite's per-witness sub-scores, the combiner, and the dominant witness.

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
