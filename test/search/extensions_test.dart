import 'package:string_search_algorithms/search.dart';
import 'package:test/test.dart';

void main() {
  final text = 'The quick brown fox jumps over the lazy dog';
  final pattern = 'fox';

  group('Search Extensions', () {
    test('indexOfPattern', () {
      expect(text.indexOfPattern(pattern), equals(16));
    });

    test('containsPattern', () {
      expect(text.containsPattern('lazy'), isTrue);
    });

    test('findAllMatches', () {
      final matches = 'aba aba'.findAllMatches('aba');
      expect(matches.length, equals(2));
    });
  });
}
