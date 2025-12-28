import 'package:string_search_algorithms/src/common/lru_cache.dart';
import 'package:string_search_algorithms/src/similarity/options/normalization_options.dart';
import 'package:string_search_algorithms/src/similarity/processing/unicode/diacritics.dart';

/// Handles string normalization based on provided [NormalizationOptions].
class StringNormalizer {
  /// Creates a [StringNormalizer].
  StringNormalizer({
    required this.options,
    this.cache,
  });

  /// The options to apply.
  final NormalizationOptions options;

  /// Cache for normalized strings. Key is the original input string.
  final LruCache<String, String>? cache;

  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  // Keep letters, numbers, and whitespace; remove everything else.
  static final RegExp _specialCharsRegex =
      RegExp(r'[^\p{L}\p{N}\s]', unicode: true);

  /// Normalizes [input] according to [options].
  String normalize(String input) {
    // If normalization is disabled, return unchanged.
    if (!options.enabled) return input;

    // Cache lookup (if provided).
    final cached = cache?.get(input);
    if (cached != null) return cached;

    var result = input;

    // Pre-processing hook (if any).
    final pre = options.preProcessor;
    if (pre != null) {
      result = pre(result);
    }

    // Accent/diacritic removal.
    if (options.removeAccents) {
      result = removeDiacritics(result);
    }

    // Standard transformations.
    if (options.trimWhitespace) {
      result = result.trim();
    }
    if (options.removeSpaces) {
      result = result.replaceAll(_whitespaceRegex, '');
    }
    if (options.toLowerCase) {
      // Dart's built-in toLowerCase() is not locale-sensitive.
      // The locale option is reserved for future enhancements.
      result = result.toLowerCase();
    }
    if (options.removeSpecialChars) {
      result = result.replaceAll(_specialCharsRegex, '');
    }

    // Post-processing hook (if any).
    final post = options.postProcessor;
    if (post != null) {
      result = post(result);
    }

    // Cache store.
    cache?.put(input, result);

    return result;
  }
}
