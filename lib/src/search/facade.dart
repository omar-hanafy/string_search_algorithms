import 'algorithms/search_algorithm.dart';
import 'engine.dart';
import 'models/compiled_pattern.dart';
import 'models/search_match.dart';

class StringSearch {
  static const StringSearchEngine _engine = StringSearchEngine();

  static CompiledPattern compile(
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return _engine.compile(pattern, algorithm: algorithm);
  }

  static int indexOf(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    return _engine.indexOf(
      text,
      pattern,
      algorithm: algorithm,
      start: start,
    );
  }

  static bool contains(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
    int start = 0,
  }) {
    return _engine.contains(
      text,
      pattern,
      algorithm: algorithm,
      start: start,
    );
  }

  static List<SearchMatch> findAll(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return _engine.findAll(
      text,
      pattern,
      algorithm: algorithm,
    );
  }

  static List<int> findAllIndices(
    String text,
    String pattern, {
    SearchAlgorithm algorithm = SearchAlgorithm.boyerMoore,
  }) {
    return _engine.findAllIndices(
      text,
      pattern,
      algorithm: algorithm,
    );
  }
}
