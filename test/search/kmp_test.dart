import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  final text = 'The quick brown fox jumps over the lazy dog';
  final pattern = 'fox';

  group('KMP', () {
    test('indexOf', () {
      expect(
          StringSearch.indexOf(text, pattern, algorithm: SearchAlgorithm.kmp),
          equals(16));
    });

    test('findAll', () {
      final t = 'aba aba aba';
      final p = 'aba';
      // Indices: 0, 4, 8
      final matches =
          StringSearch.findAll(t, p, algorithm: SearchAlgorithm.kmp);
      expect(matches.length, equals(3));
      expect(matches[0].index, equals(0));
      expect(matches[1].index, equals(4));
      expect(matches[2].index, equals(8));
    });
    
    test('not found', () {
        expect(StringSearch.indexOf(text, 'cat', algorithm: SearchAlgorithm.kmp), equals(-1));
    });
  });
}
