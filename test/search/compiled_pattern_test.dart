import 'package:string_search_algorithms/string_search_algorithms.dart';
import 'package:test/test.dart';

void main() {
  final text = 'The quick brown fox jumps over the lazy dog';
  final pattern = 'fox';

  group('Compiled Pattern', () {
    test('KMP compiled', () {
      final compiled =
          StringSearch.compile(pattern, algorithm: SearchAlgorithm.kmp);
      expect(compiled.indexOfIn(text), equals(16));
      expect(compiled.containsIn(text), isTrue);
    });
    
    test('Reuse compiled', () {
        final compiled = StringSearch.compile('abc', algorithm: SearchAlgorithm.boyerMoore);
        expect(compiled.containsIn('xyzabc'), isTrue);
        expect(compiled.containsIn('123'), isFalse);
    });
  });
}
