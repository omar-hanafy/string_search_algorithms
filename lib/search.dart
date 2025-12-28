/// Substring search APIs and algorithms.
///
/// Use [StringSearch] for stateless convenience helpers or
/// [StringSearchEngine] when you want instance-based control and reuse.
library;

export 'src/common/exceptions.dart';

export 'src/search/facade.dart';
export 'src/search/engine.dart';
export 'src/search/extensions/string_search_extensions.dart';

export 'src/search/algorithms/search_algorithm.dart';
export 'src/search/models/search_match.dart';
export 'src/search/models/compiled_pattern.dart';
