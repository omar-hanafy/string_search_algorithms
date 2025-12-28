# Changelog

## 0.1.0

- **Initial Release** with production-grade architecture.
- **Modules**: Split into `similarity` and `search` libraries.
- **Engine**: Added `StringSimilarityEngine` and `StringSearchEngine` for instance-based configuration and caching.
- **Similarity**:
    - Added algorithms: Dice Coefficient, Levenshtein, Jaro, Jaro-Winkler, Cosine, Jaccard, N-gram, Hamming, LCS, Soundex, Metaphone.
    - Added `SimilarityOptions` for detailed control over normalization and caching.
    - Added `findMatches` and `findBestMatch` for fuzzy searching.
- **Search**:
    - Added algorithms: KMP, Boyer-Moore, Rabin-Karp, Standard.
    - Added `CompiledPattern` for optimized repeated searching.
- **Extensions**: Added ergonomic extension methods on `String`.
