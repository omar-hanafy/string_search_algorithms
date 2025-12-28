import 'package:string_search_algorithms/src/common/typedefs.dart';

/// Configuration options for string normalization.
class NormalizationOptions {
  /// Creates a [NormalizationOptions].
  const NormalizationOptions({
    this.enabled = true,
    this.trimWhitespace = true,
    this.removeSpaces = false,
    this.toLowerCase = true,
    this.removeSpecialChars = false,
    this.removeAccents = false,
    this.locale,
    this.preProcessor,
    this.postProcessor,
    this.tokenizer,
  });

  /// Whether normalization is enabled (default: true).
  final bool enabled;

  /// Whether to trim leading/trailing whitespace (default: true).
  final bool trimWhitespace;

  /// Whether to remove all whitespace characters (default: false).
  final bool removeSpaces;

  /// Whether to convert to lower case (default: true).
  final bool toLowerCase;

  /// Whether to remove special characters (non-alphanumeric) (default: false).
  final bool removeSpecialChars;

  /// Whether to remove accents/diacritics (default: false).
  final bool removeAccents;

  /// Locale identifier for locale-sensitive operations (reserved for future
  /// use).
  final String? locale;

  /// Custom function to run before standard normalization.
  final PreProcessor? preProcessor;

  /// Custom function to run after standard normalization.
  final PostProcessor? postProcessor;

  /// Tokenizer used by token-based metrics (cosine/jaccard/overlap/tversky).
  final Tokenizer? tokenizer;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  NormalizationOptions copyWith({
    bool? enabled,
    bool? trimWhitespace,
    bool? removeSpaces,
    bool? toLowerCase,
    bool? removeSpecialChars,
    bool? removeAccents,
    String? locale,
    PreProcessor? preProcessor,
    PostProcessor? postProcessor,
    Tokenizer? tokenizer,
  }) {
    return NormalizationOptions(
      enabled: enabled ?? this.enabled,
      trimWhitespace: trimWhitespace ?? this.trimWhitespace,
      removeSpaces: removeSpaces ?? this.removeSpaces,
      toLowerCase: toLowerCase ?? this.toLowerCase,
      removeSpecialChars: removeSpecialChars ?? this.removeSpecialChars,
      removeAccents: removeAccents ?? this.removeAccents,
      locale: locale ?? this.locale,
      preProcessor: preProcessor ?? this.preProcessor,
      postProcessor: postProcessor ?? this.postProcessor,
      tokenizer: tokenizer ?? this.tokenizer,
    );
  }
}
