typedef SimilarityScore = double;
typedef Distance = int;

typedef PreProcessor = String Function(String);
typedef PostProcessor = String Function(String);
typedef Tokenizer = List<String> Function(String);

enum SimilarityAlgorithm {
  diceCoefficient,
  levenshtein,
  damerauLevenshtein,
  osa,
  jaro,
  jaroWinkler,
  cosine,
  jaccard,
  overlapCoefficient,
  tversky,
  ngram,
  hamming,
  lcs,
  soundex,
  metaphone,
}
