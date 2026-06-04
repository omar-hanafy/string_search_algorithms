/// Represents a similarity score between 0.0 (no match) and 1.0 (exact match).
typedef SimilarityScore = double;

/// Represents an edit distance (integer count of operations).
typedef Distance = int;

/// Function that transforms a string before processing (e.g. trimming).
typedef PreProcessor = String Function(String);

/// Function that transforms a string after normalization.
typedef PostProcessor = String Function(String);

/// Function that splits a string into a list of tokens.
typedef Tokenizer = List<String> Function(String);

/// Enumeration of supported string similarity/distance algorithms.
enum SimilarityAlgorithm {
  /// Dice Coefficient (bigram similarity).
  diceCoefficient,

  /// Levenshtein Edit Distance.
  levenshtein,

  /// Damerau-Levenshtein Distance (includes transpositions).
  damerauLevenshtein,

  /// Optimal String Alignment Distance (restricted transpositions).
  osa,

  /// Jaro Similarity.
  jaro,

  /// Jaro-Winkler Similarity.
  jaroWinkler,

  /// Cosine Similarity (token-based).
  cosine,

  /// Jaccard Index (token-based).
  jaccard,

  /// Overlap Coefficient (subset similarity).
  overlapCoefficient,

  /// Tversky Index (asymmetric set similarity).
  tversky,

  /// N-gram Similarity (character-based).
  ngram,

  /// Hamming Distance.
  hamming,

  /// Longest Common Subsequence.
  lcs,

  /// Soundex (phonetic).
  soundex,

  /// Metaphone (phonetic).
  metaphone,

  /// Composite similarity: a calibrated ensemble that combines several
  /// complementary witness algorithms into one stable, comparable score.
  ///
  /// Unlike single metrics, this is robust across mixed inputs (typos, word
  /// reordering, containment) and safe to use in ranking. Configure it via
  /// [AlgorithmOptions.composite].
  composite,
}
