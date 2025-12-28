import 'package:string_search_algorithms/src/similarity/context.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';

/// Soundex phonetic similarity metric.
///
/// This metric encodes each normalized input string to a 4-character Soundex
/// code,
/// then returns:
/// - 1.0 if both codes match
/// - 0.0 otherwise
///
/// Edge cases:
/// - If both inputs produce an empty code (no ASCII letters), returns 1.0
/// - If only one produces an empty code, returns 0.0
class SoundexMetric implements SimilarityMetric {
  @override
  String get id => 'soundex';

  @override
  double score(SimilarityContext ctx) {
    final codeA = _soundexCode(ctx.normalizedA);
    final codeB = _soundexCode(ctx.normalizedB);

    if (codeA.isEmpty && codeB.isEmpty) return 1.0;
    if (codeA.isEmpty || codeB.isEmpty) return 0.0;

    return codeA == codeB ? 1.0 : 0.0;
  }
}

// Standard Soundex mapping for English names.
//
// We intentionally only map ASCII letters A-Z after filtering, for performance
// and predictable behavior. NormalizationOptions.removeAccents can be used
// upstream to improve behavior on common Latin characters.
const Map<String, String> _soundexMap = <String, String>{
  'B': '1',
  'F': '1',
  'P': '1',
  'V': '1',
  'C': '2',
  'G': '2',
  'J': '2',
  'K': '2',
  'Q': '2',
  'S': '2',
  'X': '2',
  'Z': '2',
  'D': '3',
  'T': '3',
  'L': '4',
  'M': '5',
  'N': '5',
  'R': '6',
};

bool _isVowelOrY(String upperChar) {
  switch (upperChar) {
    case 'A':
    case 'E':
    case 'I':
    case 'O':
    case 'U':
    case 'Y':
      return true;
    default:
      return false;
  }
}

String _soundexCode(String input) {
  // Keep ASCII letters only (Soundex is traditionally English-centric).
  final letters = input.replaceAll(RegExp(r'[^A-Za-z]'), '');
  if (letters.isEmpty) return '';

  final firstLetter = letters[0].toUpperCase();
  final buffer = StringBuffer(firstLetter);

  // Previous code helps suppress adjacent duplicates.
  // We reset prevCode when we hit a vowel/Y to allow the same code after vowels.
  String? prevCode = _soundexMap[firstLetter];

  for (var i = 1; i < letters.length && buffer.length < 4; i++) {
    final ch = letters[i].toUpperCase();

    // H and W are treated as "silent" for our purposes; they do not reset
    // prevCode.
    if (ch == 'H' || ch == 'W') continue;

    // Vowels and Y reset the duplicate suppression boundary.
    if (_isVowelOrY(ch)) {
      prevCode = null;
      continue;
    }

    final code = _soundexMap[ch];
    if (code == null) {
      // Any other unmapped letter acts like a separator.
      prevCode = null;
      continue;
    }

    if (code != prevCode) {
      buffer.write(code);
      prevCode = code;
    }
  }

  // Pad with trailing zeros.
  while (buffer.length < 4) {
    buffer.write('0');
  }

  return buffer.toString();
}
