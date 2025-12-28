import '../context.dart';
import 'similarity_metric.dart';

/// Metaphone phonetic similarity metric (lightweight approximation).
///
/// Encodes each normalized input string to a Metaphone-like code and returns:
/// - 1.0 if both codes match
/// - 0.0 otherwise
///
/// Edge cases:
/// - If both inputs produce an empty code, returns 1.0
/// - If only one produces an empty code, returns 0.0
class MetaphoneMetric implements SimilarityMetric {
  @override
  String get id => 'metaphone';

  @override
  double score(SimilarityContext ctx) {
    final codeA = _metaphoneCode(ctx.normalizedA);
    final codeB = _metaphoneCode(ctx.normalizedB);

    if (codeA.isEmpty && codeB.isEmpty) return 1.0;
    if (codeA.isEmpty || codeB.isEmpty) return 0.0;

    return codeA == codeB ? 1.0 : 0.0;
  }
}

// Ordered replacements (longer patterns first) applied before main encoding.
const List<(String from, String to)> _metaphoneReplacements =
    <(String, String)>[
  ('sch', 'sk'),
  ('kn', 'n'),
  ('gn', 'n'),
  ('pn', 'n'),
  ('ae', 'e'),
  ('wr', 'r'),
  ('ck', 'k'),
  ('ph', 'f'),
  ('th', '0'),
];

String _metaphoneCode(String input) {
  // Metaphone is typically defined over alphabetic characters.
  // We keep ASCII letters only for predictable behavior.
  final letters = input.replaceAll(RegExp(r'[^A-Za-z]'), '');
  if (letters.isEmpty) return '';

  // Pre-transform.
  var lower = letters.toLowerCase();
  for (final (from, to) in _metaphoneReplacements) {
    lower = lower.replaceAll(from, to);
  }

  final str = lower.toUpperCase();
  final result = StringBuffer();

  const vowels = <String>{'A', 'E', 'I', 'O', 'U'};
  const simpleConsonants = <String>{'F', 'J', 'L', 'M', 'N', 'R'};

  for (var i = 0; i < str.length; i++) {
    final char = str[i];
    final prevChar = i > 0 ? str[i - 1] : '';
    final nextChar = i < str.length - 1 ? str[i + 1] : '';
    final nextNextChar = i < str.length - 2 ? str[i + 2] : '';

    // Skip duplicate consonants (not vowels).
    if (i > 0 && char == prevChar && !vowels.contains(char)) continue;

    // '0' is our internal TH marker.
    if (char == '0') {
      result.write('0');
      continue;
    }

    if (simpleConsonants.contains(char)) {
      result.write(char);
      continue;
    }

    switch (char) {
      case 'B':
        result.write('B');
        break;

      case 'C':
        if (nextChar == 'H') {
          result.write('X');
          i++; // skip H
        } else if (nextChar == 'I' || nextChar == 'E' || nextChar == 'Y') {
          result.write('S');
        } else {
          result.write('K');
        }
        break;

      case 'D':
        if (nextChar == 'G' &&
            (nextNextChar == 'E' ||
                nextNextChar == 'I' ||
                nextNextChar == 'Y')) {
          result.write('J');
          i++; // skip G
        } else {
          result.write('T');
        }
        break;

      case 'G':
        if (nextChar == 'H') {
          i++; // skip H (silent)
        } else if (nextChar == 'N' && i == str.length - 2) {
          // terminal GN is often silent => emit nothing
        } else if (nextChar == 'I' || nextChar == 'E' || nextChar == 'Y') {
          result.write('J');
        } else {
          result.write('K');
        }
        break;

      case 'H':
        // Emit H only when between vowels or at start before a vowel.
        if ((i == 0 || vowels.contains(prevChar)) && vowels.contains(nextChar)) {
          result.write('H');
        }
        break;

      case 'K':
        // Emit K unless preceded by C (CK already normalized to K).
        if (i == 0 || prevChar != 'C') {
          result.write('K');
        }
        break;

      case 'P':
        if (nextChar == 'H') {
          result.write('F');
          i++; // skip H
        } else {
          result.write('P');
        }
        break;

      case 'Q':
        result.write('K');
        break;

      case 'S':
        if (nextChar == 'H') {
          result.write('X');
          i++; // skip H
        } else if (nextChar == 'I' && (nextNextChar == 'O' || nextNextChar == 'A')) {
          result.write('X');
        } else {
          result.write('S');
        }
        break;

      case 'T':
        if (nextChar == 'H') {
          result.write('0');
          i++; // skip H
        } else if (nextChar == 'I' &&
            (nextNextChar == 'O' || nextNextChar == 'A')) {
          result.write('X');
        } else {
          result.write('T');
        }
        break;

      case 'V':
        result.write('F');
        break;

      case 'W':
      case 'Y':
        if (vowels.contains(nextChar)) {
          result.write(char);
        }
        break;

      case 'X':
        result.write('KS');
        break;

      case 'Z':
        result.write('S');
        break;

      default:
        // Ignore vowels and any other unmapped characters.
        // This keeps the encoding lightweight and predictable.
        break;
    }
  }

  return result.toString();
}
