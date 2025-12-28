import 'package:string_search_algorithms/src/common/exceptions.dart';

/// Configuration options for specific similarity algorithms.
class AlgorithmOptions {
  /// Creates an [AlgorithmOptions].
  const AlgorithmOptions({
    this.jaroWinklerPrefixScale = 0.1,
    this.jaroWinklerBoostThreshold = 0.7,
    this.ngramSize = 3,
    this.tverskyAlpha = 0.5,
    this.tverskyBeta = 0.5,
    this.stemTokens = false,
  })  : assert(ngramSize > 0),
        assert(tverskyAlpha >= 0.0),
        assert(tverskyBeta >= 0.0),
        assert(jaroWinklerPrefixScale >= 0.0 && jaroWinklerPrefixScale <= 0.25),
        assert(jaroWinklerBoostThreshold >= 0.0 &&
            jaroWinklerBoostThreshold <= 1.0);

  /// Scaling factor for the Jaro-Winkler prefix adjustment (default: 0.1).
  final double jaroWinklerPrefixScale;

  /// Minimum Jaro score required to apply the Winkler boost (default: 0.7).
  final double jaroWinklerBoostThreshold;

  /// The size of n-grams (e.g., 3 for trigrams) (default: 3).
  final int ngramSize;

  /// The alpha parameter for Tversky index (default: 0.5).
  final double tverskyAlpha;

  /// The beta parameter for Tversky index (default: 0.5).
  final double tverskyBeta;

  /// Whether to stem tokens before comparing (default: false).
  final bool stemTokens;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  AlgorithmOptions copyWith({
    double? jaroWinklerPrefixScale,
    double? jaroWinklerBoostThreshold,
    int? ngramSize,
    double? tverskyAlpha,
    double? tverskyBeta,
    bool? stemTokens,
  }) {
    return AlgorithmOptions(
      jaroWinklerPrefixScale:
          jaroWinklerPrefixScale ?? this.jaroWinklerPrefixScale,
      jaroWinklerBoostThreshold:
          jaroWinklerBoostThreshold ?? this.jaroWinklerBoostThreshold,
      ngramSize: ngramSize ?? this.ngramSize,
      tverskyAlpha: tverskyAlpha ?? this.tverskyAlpha,
      tverskyBeta: tverskyBeta ?? this.tverskyBeta,
      stemTokens: stemTokens ?? this.stemTokens,
    );
  }

  /// Runtime validation helper. Must throw [InvalidConfigurationException]
  /// (not AssertionError) when invalid.
  void validate() {
    if (ngramSize <= 0) {
      throw InvalidConfigurationException(
        'ngramSize must be > 0',
        {'ngramSize': ngramSize},
      );
    }
    if (tverskyAlpha < 0.0 || tverskyAlpha.isNaN) {
      throw InvalidConfigurationException(
        'tverskyAlpha must be >= 0.0',
        {'tverskyAlpha': tverskyAlpha},
      );
    }
    if (tverskyBeta < 0.0 || tverskyBeta.isNaN) {
      throw InvalidConfigurationException(
        'tverskyBeta must be >= 0.0',
        {'tverskyBeta': tverskyBeta},
      );
    }
    if (jaroWinklerPrefixScale.isNaN ||
        jaroWinklerPrefixScale < 0.0 ||
        jaroWinklerPrefixScale > 0.25) {
      throw InvalidConfigurationException(
        'jaroWinklerPrefixScale must be between 0.0 and 0.25',
        {'jaroWinklerPrefixScale': jaroWinklerPrefixScale},
      );
    }
    if (jaroWinklerBoostThreshold.isNaN ||
        jaroWinklerBoostThreshold < 0.0 ||
        jaroWinklerBoostThreshold > 1.0) {
      throw InvalidConfigurationException(
        'jaroWinklerBoostThreshold must be between 0.0 and 1.0',
        {'jaroWinklerBoostThreshold': jaroWinklerBoostThreshold},
      );
    }
  }
}
