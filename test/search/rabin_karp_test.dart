import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  final text = 'The quick brown fox jumps over the lazy dog';
  final pattern = 'fox';

  group('Rabin-Karp', () {
    test('indexOf', () {
      expect(
          StringSearch.indexOf(text, pattern,
              algorithm: SearchAlgorithm.rabinKarp),
          equals(16));
    });

    test('findAll', () {
      final t = 'aba aba aba';
      final p = 'aba';
      final matches =
          StringSearch.findAll(t, p, algorithm: SearchAlgorithm.rabinKarp);
      expect(matches.length, equals(3));
      expect(matches[0].index, equals(0));
      expect(matches[1].index, equals(4));
      expect(matches[2].index, equals(8));
    });
  });
}
