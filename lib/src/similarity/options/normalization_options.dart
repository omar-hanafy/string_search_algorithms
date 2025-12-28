import '../../common/typedefs.dart';

class NormalizationOptions {
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

  final bool enabled;
  final bool trimWhitespace;
  final bool removeSpaces;
  final bool toLowerCase;
  final bool removeSpecialChars;
  final bool removeAccents;

  final String? locale;

  final PreProcessor? preProcessor;
  final PostProcessor? postProcessor;

  /// Tokenizer used by token-based metrics (cosine/jaccard/overlap/tversky).
  final Tokenizer? tokenizer;

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
