import 'package:string_search_algorithms/search.dart';
import 'package:test/test.dart';

void main() {
  const engine = StringSearchEngine();

  for (final algorithm in SearchAlgorithm.values) {
    group(algorithm.name, () {
      test('all public search entry points include overlapping matches', () {
        const cases = [
          (text: 'ababa', pattern: 'aba', indices: [0, 2]),
          (text: 'aaaaa', pattern: 'aaa', indices: [0, 1, 2]),
          (text: '😀😀😀', pattern: '😀😀', indices: [0, 2]),
          (text: 'abc', pattern: 'abcd', indices: <int>[]),
        ];

        for (final item in cases) {
          final compiled = StringSearch.compile(
            item.pattern,
            algorithm: algorithm,
          );
          final matches = [
            for (final index in item.indices)
              SearchMatch(
                index: index,
                length: item.pattern.length,
                algorithm: algorithm,
              ),
          ];

          expect(compiled.findAllIndicesIn(item.text), item.indices);
          expect(compiled.findAllIn(item.text), matches);
          expect(
            engine.findAllIndices(
              item.text,
              item.pattern,
              algorithm: algorithm,
            ),
            item.indices,
          );
          expect(
            engine.findAll(item.text, item.pattern, algorithm: algorithm),
            matches,
          );
          expect(
            StringSearch.findAllIndices(
              item.text,
              item.pattern,
              algorithm: algorithm,
            ),
            item.indices,
          );
          expect(
            StringSearch.findAll(item.text, item.pattern, algorithm: algorithm),
            matches,
          );
          expect(
            item.text.findAllMatchIndices(item.pattern, algorithm: algorithm),
            item.indices,
          );
          expect(
            item.text.findAllMatches(item.pattern, algorithm: algorithm),
            matches,
          );
        }
      });

      test('compiled search respects every valid start offset', () {
        const text = 'ababa';
        const pattern = 'aba';
        final compiled = engine.compile(pattern, algorithm: algorithm);
        for (var start = 0; start <= text.length; start++) {
          final expected = text.indexOf(pattern, start);
          expect(compiled.indexOfIn(text, start: start), expected);
          expect(compiled.containsIn(text, start: start), expected >= 0);
        }

        for (final start in [-1, text.length + 1]) {
          expect(
            () => compiled.indexOfIn(text, start: start),
            throwsA(isA<InvalidInputException>()),
          );
          expect(
            () => compiled.containsIn(text, start: start),
            throwsA(isA<InvalidInputException>()),
          );
        }
      });
    });
  }
}
