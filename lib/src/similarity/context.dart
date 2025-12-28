import 'package:string_search_algorithms/src/common/lru_cache.dart';
import 'package:string_search_algorithms/src/similarity/options/similarity_options.dart';
import 'package:string_search_algorithms/src/similarity/processing/tokenizer.dart';

/// Key for caching n-grams (string + n).
class NgramCacheKey {
  /// Creates a key for [text] and size [n].
  const NgramCacheKey(this.text, this.n);

  /// The text source.
  final String text;

  /// The n-gram size.
  final int n;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NgramCacheKey && other.text == text && other.n == n);
  }

  @override
  int get hashCode => Object.hash(text, n);
}

/// Holds references to the various caches used by the engine.
class SimilarityCaches {
  /// Creates a [SimilarityCaches] container.
  SimilarityCaches({
    this.normalized,
    this.bigrams,
    this.ngrams,
  });

  /// Cache for normalized strings.
  final LruCache<String, String>? normalized;

  /// Cache for bigram frequency maps.
  final LruCache<String, Map<String, int>>? bigrams;

  /// Cache for n-gram lists.
  final LruCache<NgramCacheKey, List<String>>? ngrams;
}

/// Context passed to [SimilarityMetric.score].
///
/// Contains the input strings (original and normalized), global options,
/// and access to shared caches/tokenizer.
class SimilarityContext {
  /// Creates a [SimilarityContext].
  SimilarityContext({
    required this.originalA,
    required this.originalB,
    required this.normalizedA,
    required this.normalizedB,
    required this.options,
    required this.caches,
    required this.tokenizer,
  });

  /// The first original input string.
  final String originalA;

  /// The second original input string.
  final String originalB;

  /// The first input string after normalization.
  final String normalizedA;

  /// The second input string after normalization.
  final String normalizedB;

  /// Global similarity options.
  final SimilarityOptions options;

  /// Shared caches.
  final SimilarityCaches caches;

  /// Shared tokenizer instance.
  final StringTokenizer tokenizer;

  /// Returns whitespace/custom-tokenizer tokens (optionally stemmed).
  List<String> tokens(String normalized) {
    return tokenizer.tokenize(
      normalized,
      tokenizer: options.normalization.tokenizer,
      stem: options.algorithms.stemTokens,
    );
  }

  /// Returns bigram frequency counts for a normalized string (cached if
  /// enabled).
  Map<String, int> bigramCounts(String normalized) {
    if (normalized.length < 2) return const <String, int>{};

    final cache = caches.bigrams;
    if (options.cache.enabled && cache != null) {
      final cached = cache.get(normalized);
      if (cached != null) {
        // Return as-is; metrics must treat this as read-only.
        return cached;
      }
    }

    final counts = <String, int>{};
    final codeUnits = normalized.codeUnits;
    for (var i = 0; i < codeUnits.length - 1; i++) {
      final bigram =
          String.fromCharCodes(<int>[codeUnits[i], codeUnits[i + 1]]);
      counts[bigram] = (counts[bigram] ?? 0) + 1;
    }

    final unmodifiable = Map<String, int>.unmodifiable(counts);
    if (options.cache.enabled && cache != null) {
      cache.put(normalized, unmodifiable);
    }
    return unmodifiable;
  }

  /// Returns n-grams for a normalized string (cached if enabled).
  /// If [n] is null, uses [options.algorithms.ngramSize].
  List<String> ngrams(String normalized, {int? n}) {
    final size = n ?? options.algorithms.ngramSize;
    if (size <= 0) return const <String>[];
    if (normalized.length < size) return const <String>[];

    final cache = caches.ngrams;
    final key = NgramCacheKey(normalized, size);

    if (options.cache.enabled && cache != null) {
      final cached = cache.get(key);
      if (cached != null) {
        // Return as-is; metrics must treat this as read-only.
        return cached;
      }
    }

    final out = <String>[];
    for (var i = 0; i <= normalized.length - size; i++) {
      out.add(normalized.substring(i, i + size));
    }

    final unmodifiable = List<String>.unmodifiable(out);
    if (options.cache.enabled && cache != null) {
      cache.put(key, unmodifiable);
    }
    return unmodifiable;
  }
}
