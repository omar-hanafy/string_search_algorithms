import '../common/exceptions.dart';
import 'algorithms/boyer_moore.dart';
import 'algorithms/kmp.dart';
import 'algorithms/rabin_karp.dart';
import 'algorithms/search_algorithm.dart';
import 'models/compiled_pattern.dart';
import 'models/search_match.dart';

class StringSearchEngine {
  const StringSearchEngine();

  CompiledPattern compile(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    if (pattern.isEmpty) {
      throw InvalidInputException(
        'Pattern must not be empty for compile().',
        {'pattern': pattern},
      );
    }

    switch (algorithm) {
      case SearchAlgorithm.kmp:
        return compileKmp(pattern);
      case SearchAlgorithm.boyerMoore:
        return compileBoyerMoore(pattern);
      case SearchAlgorithm.rabinKarp:
        return compileRabinKarp(pattern);
    }
  }

  int indexOf(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    _validateStart(text, start);

    // Spec: empty pattern returns start.
    if (pattern.isEmpty) return start;

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.indexOfIn(text, start: start);
  }

  bool contains(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    _validateStart(text, start);

    // Spec: empty pattern returns true.
    if (pattern.isEmpty) return true;

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.containsIn(text, start: start);
  }

  List<SearchMatch> findAll(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    // Spec: findAll with empty pattern throws.
    if (pattern.isEmpty) {
      throw InvalidInputException(
        'Pattern must not be empty for findAll().',
        {'pattern': pattern},
      );
    }

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.findAllIn(text);
  }

  List<int> findAllIndices(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    // Spec: findAllIndices with empty pattern throws.
    if (pattern.isEmpty) {
      throw InvalidInputException(
        'Pattern must not be empty for findAllIndices().',
        {'pattern': pattern},
      );
    }

    final compiled = compile(pattern, algorithm: algorithm);
    return compiled.findAllIndicesIn(text);
  }

  static void _validateStart(String text, int start) {
    // Spec: start must be 0 <= start <= text.length (inclusive).
    if (start < 0 || start > text.length) {
      throw InvalidInputException(
        'Invalid start index. Must satisfy 0 <= start <= text.length.',
        {'start': start, 'textLength': text.length},
      );
    }
  }
}
