import 'package:string_search_algorithms/src/common/exceptions.dart';
import 'package:string_search_algorithms/src/common/lru_cache.dart';
import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/context.dart';
import 'package:string_search_algorithms/src/similarity/metrics/registry.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';
import 'package:string_search_algorithms/src/similarity/models/fuzzy_match.dart';
import 'package:string_search_algorithms/src/similarity/models/similarity_result.dart';
import 'package:string_search_algorithms/src/similarity/options/similarity_options.dart';
import 'package:string_search_algorithms/src/similarity/processing/normalizer.dart';
import 'package:string_search_algorithms/src/similarity/processing/tokenizer.dart';

/// Engine for performing string similarity comparisons and fuzzy matching.
///
/// Inputs are normalized according to [SimilarityOptions.normalization] before
/// scoring. Caches are per-engine and controlled by
/// [SimilarityOptions.cache].
class StringSimilarityEngine {
  /// Creates a [StringSimilarityEngine] with the given [options].
  ///
  /// If [registry] is not provided, uses the built-in algorithms.
  StringSimilarityEngine({
    this.options = const SimilarityOptions(),
    SimilarityMetricRegistry? registry,
  })  : _registry = registry ?? SimilarityMetricRegistry.builtIn(),
        _tokenizer = const StringTokenizer() {
    // Validate algorithm options at runtime (asserts can be disabled in
    // release).
    options.algorithms.validate();

    // Initialize per-instance caches (or disable them).
    if (options.cache.enabled) {
      _normalizedCache = LruCache<String, String>(
        capacity: options.cache.normalizedCapacity,
      );
      _bigramCache = LruCache<String, Map<String, int>>(
        capacity: options.cache.bigramCapacity,
      );
      _ngramCache = LruCache<NgramCacheKey, List<String>>(
        capacity: options.cache.ngramCapacity,
      );
    } else {
      _normalizedCache = null;
      _bigramCache = null;
      _ngramCache = null;
    }

    _caches = SimilarityCaches(
      normalized: _normalizedCache,
      bigrams: _bigramCache,
      ngrams: _ngramCache,
    );

    _normalizer = StringNormalizer(
      options: options.normalization,
      cache: _normalizedCache,
    );
  }

  /// The configuration options for this engine.
  final SimilarityOptions options;

  final SimilarityMetricRegistry _registry;
  final StringTokenizer _tokenizer;

  late final LruCache<String, String>? _normalizedCache;
  late final LruCache<String, Map<String, int>>? _bigramCache;
  late final LruCache<NgramCacheKey, List<String>>? _ngramCache;

  late final SimilarityCaches _caches;
  late final StringNormalizer _normalizer;

  /// Calculates the similarity score (0.0 to 1.0) between [a] and [b].
  ///
  /// Uses [algorithm] (default: Jaro-Winkler) unless a custom [metric] is
  /// provided.
  ///
  /// Example:
  /// ```dart
  /// final engine = StringSimilarityEngine();
  /// engine.compare('kitten', 'sitting'); // 0.746...
  /// ```
  SimilarityScore compare(
    String a,
    String b, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    SimilarityMetric? metric,
  }) {
    final normalizedA = _normalizer.normalize(a);
    final normalizedB = _normalizer.normalize(b);

    return _scoreWithNormalized(
      originalA: a,
      originalB: b,
      normalizedA: normalizedA,
      normalizedB: normalizedB,
      algorithm: algorithm,
      metric: metric,
    );
  }

  /// Calculates similarity with detailed metadata (execution time,
  /// normalization, etc.).
  ///
  /// Example:
  /// ```dart
  /// final result = engine.compareWithDetails('kitten', 'sitting');
  /// print(result.score);
  /// ```
  SimilarityResult compareWithDetails(
    String a,
    String b, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
  }) {
    final sw = Stopwatch()..start();

    final normalizedA = _normalizer.normalize(a);
    final normalizedB = _normalizer.normalize(b);

    final outcome = _scoreWithNormalizedDetailed(
      originalA: a,
      originalB: b,
      normalizedA: normalizedA,
      normalizedB: normalizedB,
      algorithm: algorithm,
    );

    sw.stop();

    return SimilarityResult(
      score: outcome.score,
      algorithm: algorithm,
      inputA: a,
      inputB: b,
      normalizedA: normalizedA,
      normalizedB: normalizedB,
      metadata: outcome.metadata,
      elapsed: sw.elapsed,
    );
  }

  /// Finds matches for [query] in [candidates] with a score >= [minScore].
  ///
  /// Example:
  /// ```dart
  /// engine.findMatches('apple', ['aple', 'pear', 'app'], minScore: 0.8);
  /// ```
  List<FuzzyMatch<String>> findMatches(
    String query,
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    int? topK,
    bool sort = true,
    bool includeNormalized = false,
  }) {
    _validateMinScore(minScore);
    _validateTopK(topK);

    final normalizedQuery = _normalizer.normalize(query);

    final results = <FuzzyMatch<String>>[];

    for (final candidate in candidates) {
      final normalizedCandidate = _normalizer.normalize(candidate);

      final score = _scoreWithNormalized(
        originalA: query,
        originalB: candidate,
        normalizedA: normalizedQuery,
        normalizedB: normalizedCandidate,
        algorithm: algorithm,
      );

      if (score >= minScore) {
        results.add(
          FuzzyMatch<String>(
            value: candidate,
            score: score,
            algorithm: algorithm,
            normalizedValue: includeNormalized ? normalizedCandidate : null,
          ),
        );
      }
    }

    if (sort) {
      results.sort((a, b) => b.score.compareTo(a.score));
    }

    if (topK != null && results.length > topK) {
      return results.sublist(0, topK);
    }

    return results;
  }

  /// Finds the single best match for [query] in [candidates].
  ///
  /// Example:
  /// ```dart
  /// engine.findBestMatch('apple', ['aple', 'pear']); // FuzzyMatch('aple')
  /// ```
  FuzzyMatch<String>? findBestMatch(
    String query,
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    bool includeNormalized = false,
  }) {
    _validateMinScore(minScore);

    final normalizedQuery = _normalizer.normalize(query);

    String? bestValue;
    String? bestNormalized;
    var bestScore = double.negativeInfinity;

    for (final candidate in candidates) {
      final normalizedCandidate = _normalizer.normalize(candidate);

      final score = _scoreWithNormalized(
        originalA: query,
        originalB: candidate,
        normalizedA: normalizedQuery,
        normalizedB: normalizedCandidate,
        algorithm: algorithm,
      );

      if (score > bestScore) {
        bestScore = score;
        bestValue = candidate;
        if (includeNormalized) {
          bestNormalized = normalizedCandidate;
        }
      }
    }

    if (bestValue == null) return null;
    if (bestScore < minScore) return null;

    return FuzzyMatch<String>(
      value: bestValue,
      score: bestScore,
      algorithm: algorithm,
      normalizedValue: includeNormalized ? bestNormalized : null,
    );
  }

  /// Ranks [candidates] by similarity to [query].
  ///
  /// Example:
  /// ```dart
  /// engine.rankByRelevance('apple', ['pear', 'aple', 'app']);
  /// // [FuzzyMatch('aple'), FuzzyMatch('app'), FuzzyMatch('pear')]
  /// ```
  List<FuzzyMatch<String>> rankByRelevance(
    String query,
    Iterable<String> candidates, {
    SimilarityAlgorithm algorithm = SimilarityAlgorithm.jaroWinkler,
    double minScore = 0.0,
    bool includeNormalized = false,
  }) {
    return findMatches(
      query,
      candidates,
      algorithm: algorithm,
      minScore: minScore,
      topK: null,
      sort: true,
      includeNormalized: includeNormalized,
    );
  }

  SimilarityScore _scoreWithNormalized({
    required String originalA,
    required String originalB,
    required String normalizedA,
    required String normalizedB,
    required SimilarityAlgorithm algorithm,
    SimilarityMetric? metric,
  }) {
    // Global invariant (as specified in Master Architecture Plan).
    if (normalizedA.isEmpty && normalizedB.isEmpty) return 1.0;
    if (normalizedA.isEmpty || normalizedB.isEmpty) return 0.0;

    // Fast path for identical normalized strings.
    if (normalizedA == normalizedB) return 1.0;

    final effectiveMetric = metric ?? _registry.metricFor(algorithm);

    final ctx = SimilarityContext(
      originalA: originalA,
      originalB: originalB,
      normalizedA: normalizedA,
      normalizedB: normalizedB,
      options: options,
      caches: _caches,
      tokenizer: _tokenizer,
    );

    final raw = effectiveMetric.score(ctx);
    return _sanitizeScore(raw);
  }

  /// Like [_scoreWithNormalized] but also returns explanation metadata when the
  /// resolved metric implements [ExplainableMetric]. Used by
  /// [compareWithDetails]; kept separate so the hot scoring paths stay lean.
  ({SimilarityScore score, Map<String, Object?> metadata})
      _scoreWithNormalizedDetailed({
    required String originalA,
    required String originalB,
    required String normalizedA,
    required String normalizedB,
    required SimilarityAlgorithm algorithm,
  }) {
    const emptyMetadata = <String, Object?>{};

    if (normalizedA.isEmpty && normalizedB.isEmpty) {
      return (score: 1.0, metadata: emptyMetadata);
    }
    if (normalizedA.isEmpty || normalizedB.isEmpty) {
      return (score: 0.0, metadata: emptyMetadata);
    }
    if (normalizedA == normalizedB) {
      return (score: 1.0, metadata: emptyMetadata);
    }

    final effectiveMetric = _registry.metricFor(algorithm);

    final ctx = SimilarityContext(
      originalA: originalA,
      originalB: originalB,
      normalizedA: normalizedA,
      normalizedB: normalizedB,
      options: options,
      caches: _caches,
      tokenizer: _tokenizer,
    );

    if (effectiveMetric is ExplainableMetric) {
      final detailed = effectiveMetric.scoreWithDetails(ctx);
      return (
        score: _sanitizeScore(detailed.score),
        metadata: detailed.details,
      );
    }

    return (
      score: _sanitizeScore(effectiveMetric.score(ctx)),
      metadata: emptyMetadata,
    );
  }

  SimilarityScore _sanitizeScore(double value) {
    if (value.isNaN || value.isInfinite) return 0.0;
    if (value <= 0.0) return 0.0;
    if (value >= 1.0) return 1.0;
    return value;
  }

  void _validateMinScore(double minScore) {
    if (minScore.isNaN || minScore.isInfinite) {
      throw InvalidInputException(
        'minScore must be a finite number.',
        {'minScore': minScore},
      );
    }
    if (minScore < 0.0 || minScore > 1.0) {
      throw InvalidInputException(
        'minScore must be in the range [0.0, 1.0].',
        {'minScore': minScore},
      );
    }
  }

  void _validateTopK(int? topK) {
    if (topK == null) return;
    if (topK <= 0) {
      throw InvalidInputException(
        'topK must be > 0 when provided.',
        {'topK': topK},
      );
    }
  }
}
