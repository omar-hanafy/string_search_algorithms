import '../algorithms/search_algorithm.dart';
import 'search_match.dart';

abstract interface class CompiledPattern {
  String get pattern;
  SearchAlgorithm get algorithm;

  int indexOfIn(String text, {int start = 0});

  bool containsIn(String text, {int start = 0});

  List<SearchMatch> findAllIn(String text);

  List<int> findAllIndicesIn(String text);
}
