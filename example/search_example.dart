import 'package:string_search_algorithms/search.dart';

void main() {
  print('--- String Search Example ---');

  final text = 'The quick brown fox jumps over the lazy dog';
  print('Text: "$text"');

  // 1. Simple search
  final index = StringSearch.indexOf(
    text,
    'brown',
    algorithm: SearchAlgorithm.boyerMoore,
  );
  print('Index of "brown" (Boyer-Moore): $index');

  // 2. Extensions
  if (text.containsPattern('fox')) {
    print('Text contains "lazy" (Rabin-Karp)');
  }

  // 3. Compiled Pattern (Best for repeated searches)
  // Compiling 'the' using KMP
  final pattern = StringSearch.compile('the', algorithm: SearchAlgorithm.kmp);
  
  // Note: Searching is case-sensitive by default unless you normalize manually
  final allMatches = pattern.findAllIn(text.toLowerCase());

  print('Occurrences of "the" (KMP, case-insensitive via lowerCase):');
  for (final match in allMatches) {
    print('- Found at index ${match.index}');
  }
}
