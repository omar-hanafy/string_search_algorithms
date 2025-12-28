import '../../common/typedefs.dart';
import 'stemmer.dart';

class StringTokenizer {
  const StringTokenizer();

  static final RegExp _whitespaceRegex = RegExp(r'\s+');
  static const BasicStemmer _stemmer = BasicStemmer();

  List<String> tokenize(
    String text, {
    Tokenizer? tokenizer,
    bool stem = false,
  }) {
    final rawTokens = tokenizer != null ? tokenizer(text) : _defaultTokenize(text);

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
