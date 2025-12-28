import '../../common/exceptions.dart';

class AlgorithmOptions {
  const AlgorithmOptions({
    this.jaroWinklerPrefixScale = 0.1,
    this.jaroWinklerBoostThreshold = 0.7,
    this.ngramSize = 3,
    this.tverskyAlpha = 0.5,
    this.tverskyBeta = 0.5,
    this.stemTokens = false,
  }) : assert(ngramSize > 0),
       assert(tverskyAlpha >= 0.0),
       assert(tverskyBeta >= 0.0),
       assert(jaroWinklerPrefixScale >= 0.0 && jaroWinklerPrefixScale <= 0.25),
       assert(jaroWinklerBoostThreshold >= 0.0 && jaroWinklerBoostThreshold <= 1.0);

  final double jaroWinklerPrefixScale;
  final double jaroWinklerBoostThreshold;
  final int ngramSize;
  final double tverskyAlpha;
  final double tverskyBeta;
  final bool stemTokens;

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
