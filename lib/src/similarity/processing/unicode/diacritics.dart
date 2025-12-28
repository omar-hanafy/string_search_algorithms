import 'accent_map.dart';

/// Removes common diacritics/accents using [kAccentMap].
String removeDiacritics(String input) {
  if (input.isEmpty) return input;

  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(kAccentMap[ch] ?? ch);
  }
  return buffer.toString();
}
