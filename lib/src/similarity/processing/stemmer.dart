/// Very lightweight stemmer intended for fuzzy matching token pipelines.
///
/// This is NOT a full Porter stemmer; it is intentionally simple, fast, and
/// predictable for production usage in a general-purpose library.
class BasicStemmer {
  /// Creates a [BasicStemmer].
  const BasicStemmer();

  /// Returns a stemmed version of [word].
  String stem(String word) {
    if (word.length < 4) return word;

    const suffixes = <String>['ing', 'ed', 'ly', 'es', 's'];

    for (final suffix in suffixes) {
      if (word.endsWith(suffix) && word.length - suffix.length >= 3) {
        return word.substring(0, word.length - suffix.length);
      }
    }
    return word;
  }

  /// Stems all [words] and returns a new list.
  List<String> stemAll(Iterable<String> words) {
    return words.map(stem).toList(growable: false);
  }
}
