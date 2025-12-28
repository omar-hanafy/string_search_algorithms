import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/processing/stemmer.dart';

/// Handles splitting strings into tokens (and optionally stemming them).
class StringTokenizer {
  /// Creates a [StringTokenizer].
  const StringTokenizer();

  static final RegExp _whitespaceRegex = RegExp(r'\s+');
  static const BasicStemmer _stemmer = BasicStemmer();

  /// Splits [text] into tokens.
  ///
  /// Uses [tokenizer] if provided, otherwise defaults to splitting by
  /// whitespace.
  /// If [stem] is true, applies basic English stemming to tokens.
  List<String> tokenize(
    String text, {
    Tokenizer? tokenizer,
    bool stem = false,
  }) {
    final rawTokens =
        tokenizer != null ? tokenizer(text) : _defaultTokenize(text);

    if (!stem) return rawTokens;

    return rawTokens.map(_stemmer.stem).toList(growable: false);
  }

  List<String> _defaultTokenize(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const <String>[];

    // Special-case: no whitespace => single token
    if (!_whitespaceRegex.hasMatch(trimmed)) {
      return <String>[trimmed];
    }

    return trimmed
        .split(_whitespaceRegex)
        .where((t) => t.isNotEmpty)
        .toList(growable: false);
  }
}
