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
    this.composite = const CompositeOptions(),
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

  /// Options for the composite (calibrated ensemble) algorithm.
  final CompositeOptions composite;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  AlgorithmOptions copyWith({
    double? jaroWinklerPrefixScale,
    double? jaroWinklerBoostThreshold,
    int? ngramSize,
    double? tverskyAlpha,
    double? tverskyBeta,
    bool? stemTokens,
    CompositeOptions? composite,
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
      composite: composite ?? this.composite,
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
    composite.validate();
  }
}

/// Strategy for combining witness scores in the composite metric.
enum CompositeCombiner {
  /// Take the maximum of the weighted, calibrated witness scores.
  ///
  /// Robust default: a strong signal from any single witness wins, while
  /// per-witness noise floors suppress baseline noise.
  scaledMax,

  /// Take the weighted mean of the calibrated witness scores.
  ///
  /// Smoother than [scaledMax] but dilutes a single strong signal.
  weightedMean,

  /// Take the maximum of the weighted raw witness scores (no calibration).
  ///
  /// Escape hatch for callers who want uncalibrated behavior.
  max,
}

/// Configuration for the composite (calibrated ensemble) algorithm.
///
/// The composite combines several witness metrics (Jaro-Winkler, Dice, Cosine,
/// Overlap) into one stable score. Each witness is first remapped through a
/// per-witness noise [floor] so the witnesses become comparable:
///
/// ```text
/// scaled = clamp01((raw - floor) / (1 - floor))   // raw <= floor maps to 0
/// ```
///
/// The default floors were derived empirically (the 95th percentile of each
/// witness's score on unrelated word pairs); see
/// `benchmark/composite_calibration.dart` to re-derive them.
class CompositeOptions {
  /// Creates a [CompositeOptions].
  const CompositeOptions({
    this.combiner = CompositeCombiner.scaledMax,
    this.jaroWinklerWeight = 1.0,
    this.diceWeight = 1.0,
    this.cosineWeight = 0.95,
    this.overlapWeight = 0.9,
    this.jaroWinklerFloor = 0.63,
    this.diceFloor = 0.22,
    this.cosineFloor = 0.0,
    this.overlapFloor = 0.07,
  });

  /// How witness scores are combined into the final score.
  final CompositeCombiner combiner;

  /// Trust weight for the Jaro-Winkler witness (typos / shared prefix).
  final double jaroWinklerWeight;

  /// Trust weight for the Dice witness (character bigram overlap).
  final double diceWeight;

  /// Trust weight for the Cosine witness (token / word reordering).
  final double cosineWeight;

  /// Trust weight for the Overlap witness (containment / length disparity).
  final double overlapWeight;

  /// Noise floor for the Jaro-Winkler witness (default: 0.63, empirical).
  final double jaroWinklerFloor;

  /// Noise floor for the Dice witness (default: 0.22, empirical).
  final double diceFloor;

  /// Noise floor for the Cosine witness (default: 0.0, empirical).
  final double cosineFloor;

  /// Noise floor for the Overlap witness (default: 0.07, empirical).
  final double overlapFloor;

  /// Creates a copy of this object with the given fields replaced with the new
  /// values.
  CompositeOptions copyWith({
    CompositeCombiner? combiner,
    double? jaroWinklerWeight,
    double? diceWeight,
    double? cosineWeight,
    double? overlapWeight,
    double? jaroWinklerFloor,
    double? diceFloor,
    double? cosineFloor,
    double? overlapFloor,
  }) {
    return CompositeOptions(
      combiner: combiner ?? this.combiner,
      jaroWinklerWeight: jaroWinklerWeight ?? this.jaroWinklerWeight,
      diceWeight: diceWeight ?? this.diceWeight,
      cosineWeight: cosineWeight ?? this.cosineWeight,
      overlapWeight: overlapWeight ?? this.overlapWeight,
      jaroWinklerFloor: jaroWinklerFloor ?? this.jaroWinklerFloor,
      diceFloor: diceFloor ?? this.diceFloor,
      cosineFloor: cosineFloor ?? this.cosineFloor,
      overlapFloor: overlapFloor ?? this.overlapFloor,
    );
  }

  /// Runtime validation helper. Throws [InvalidConfigurationException] when
  /// weights are negative/non-finite or floors fall outside `[0.0, 1.0)`.
  void validate() {
    void checkWeight(String name, double value) {
      if (value.isNaN || value.isInfinite || value < 0.0) {
        throw InvalidConfigurationException(
          '$name must be a finite value >= 0.0',
          {name: value},
        );
      }
    }

    void checkFloor(String name, double value) {
      if (value.isNaN || value < 0.0 || value >= 1.0) {
        throw InvalidConfigurationException(
          '$name must be in the range [0.0, 1.0)',
          {name: value},
        );
      }
    }

    checkWeight('jaroWinklerWeight', jaroWinklerWeight);
    checkWeight('diceWeight', diceWeight);
    checkWeight('cosineWeight', cosineWeight);
    checkWeight('overlapWeight', overlapWeight);
    checkFloor('jaroWinklerFloor', jaroWinklerFloor);
    checkFloor('diceFloor', diceFloor);
    checkFloor('cosineFloor', cosineFloor);
    checkFloor('overlapFloor', overlapFloor);
  }
}
