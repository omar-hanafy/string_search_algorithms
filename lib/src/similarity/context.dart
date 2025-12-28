import '../common/lru_cache.dart';
import 'options/similarity_options.dart';
import 'processing/tokenizer.dart';

class NgramCacheKey {
  const NgramCacheKey(this.text, this.n);

  final String text;
  final int n;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NgramCacheKey && other.text == text && other.n == n);
  }

  @override
  int get hashCode => Object.hash(text, n);
}

class SimilarityCaches {
  SimilarityCaches({
    this.normalized,
    this.bigrams,
    this.ngrams,
  });

  final LruCache<String, String>? normalized;
  final LruCache<String, Map<String, int>>? bigrams;
  final LruCache<NgramCacheKey, List<String>>? ngrams;
}

class SimilarityContext {
  SimilarityContext({
    required this.originalA,
    required this.originalB,
    required this.normalizedA,
    required this.normalizedB,
    required this.options,
    required this.caches,
    required this.tokenizer,
  });

  final String originalA;
  final String originalB;

  final String normalizedA;
  final String normalizedB;

  final SimilarityOptions options;
  final SimilarityCaches caches;

  final StringTokenizer tokenizer;

  /// Returns whitespace/custom-tokenizer tokens (optionally stemmed).
  List<String> tokens(String normalized) {
    return tokenizer.tokenize(
      normalized,
      tokenizer: options.normalization.tokenizer,
      stem: options.algorithms.stemTokens,
    );
  }

  /// Returns bigram frequency counts for a normalized string (cached if enabled).
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
      final bigram = String.fromCharCodes(<int>[codeUnits[i], codeUnits[i + 1]]);
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
