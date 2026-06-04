import 'dart:math' as math;

import 'package:string_search_algorithms/src/common/typedefs.dart';
import 'package:string_search_algorithms/src/similarity/context.dart';
import 'package:string_search_algorithms/src/similarity/metrics/cosine.dart';
import 'package:string_search_algorithms/src/similarity/metrics/dice_coefficient.dart';
import 'package:string_search_algorithms/src/similarity/metrics/jaro_winkler.dart';
import 'package:string_search_algorithms/src/similarity/metrics/overlap_coefficient.dart';
import 'package:string_search_algorithms/src/similarity/metrics/similarity_metric.dart';
import 'package:string_search_algorithms/src/similarity/options/algorithm_options.dart';

/// Composite similarity metric: a calibrated ensemble of complementary
/// witnesses combined into one stable, comparable score.
///
/// Instead of switching algorithm by input shape (which produces incomparable
/// scores), it always evaluates each applicable witness, remaps it through a
/// per-witness noise floor, and combines the results. Configure it via
/// [CompositeOptions] on [AlgorithmOptions.composite].
class CompositeMetric implements ExplainableMetric {
  final JaroWinklerMetric _jaroWinkler = JaroWinklerMetric();
  final DiceCoefficientMetric _dice = DiceCoefficientMetric();
  final CosineMetric _cosine = CosineMetric();
  final OverlapCoefficientMetric _overlap = OverlapCoefficientMetric();

  @override
  String get id => 'composite';

  @override
  SimilarityScore score(SimilarityContext ctx) => _evaluate(ctx).score;

  @override
  ExplainedScore scoreWithDetails(SimilarityContext ctx) {
    final outcome = _evaluate(ctx);
    return (
      score: outcome.score,
      details: <String, Object?>{
        'witnesses': outcome.witnesses,
        'combiner': outcome.combiner.name,
        if (outcome.dominant != null) 'dominant': outcome.dominant,
      },
    );
  }

  _CompositeOutcome _evaluate(SimilarityContext ctx) {
    final opts = ctx.options.algorithms.composite;
    final ngramSize = ctx.options.algorithms.ngramSize;
    final minLen = math.min(ctx.normalizedA.length, ctx.normalizedB.length);

    // Evaluate only applicable witnesses. Gating avoids empty-gram artifacts
    // (e.g. set metrics returning a spurious 1.0 on tiny inputs).
    final witnesses = <_Witness>[
      _Witness('jaroWinkler', _jaroWinkler.score(ctx), opts.jaroWinklerWeight,
          opts.jaroWinklerFloor),
      if (minLen >= 2)
        _Witness('dice', _dice.score(ctx), opts.diceWeight, opts.diceFloor),
      _Witness(
          'cosine', _cosine.score(ctx), opts.cosineWeight, opts.cosineFloor),
      if (minLen > ngramSize)
        _Witness('overlap', _overlap.score(ctx), opts.overlapWeight,
            opts.overlapFloor),
    ];

    final raw = <String, double>{
      for (final w in witnesses) w.name: w.raw,
    };

    return _CompositeOutcome(
      score: _clamp01(_combine(witnesses, opts.combiner)),
      witnesses: raw,
      dominant: _dominant(witnesses, opts.combiner),
      combiner: opts.combiner,
    );
  }

  double _combine(List<_Witness> witnesses, CompositeCombiner combiner) {
    switch (combiner) {
      case CompositeCombiner.scaledMax:
        var best = 0.0;
        for (final w in witnesses) {
          final value = w.weight * _scale(w.raw, w.floor);
          if (value > best) best = value;
        }
        return best;
      case CompositeCombiner.weightedMean:
        var acc = 0.0;
        var sumWeight = 0.0;
        for (final w in witnesses) {
          acc += w.weight * _scale(w.raw, w.floor);
          sumWeight += w.weight;
        }
        return sumWeight == 0.0 ? 0.0 : acc / sumWeight;
      case CompositeCombiner.max:
        var best = 0.0;
        for (final w in witnesses) {
          final value = w.weight * w.raw;
          if (value > best) best = value;
        }
        return best;
    }
  }

  String? _dominant(List<_Witness> witnesses, CompositeCombiner combiner) {
    String? name;
    var best = double.negativeInfinity;
    for (final w in witnesses) {
      final contribution = combiner == CompositeCombiner.max
          ? w.weight * w.raw
          : w.weight * _scale(w.raw, w.floor);
      if (contribution > best) {
        best = contribution;
        name = w.name;
      }
    }
    return name;
  }

  /// Remaps a raw witness score above its noise [floor] onto `[0, 1]`.
  double _scale(double raw, double floor) {
    if (floor <= 0.0) return _clamp01(raw);
    if (raw <= floor) return 0.0;
    return _clamp01((raw - floor) / (1.0 - floor));
  }

  double _clamp01(double value) {
    if (value.isNaN) return 0.0;
    if (value < 0.0) return 0.0;
    if (value > 1.0) return 1.0;
    return value;
  }
}

/// A single evaluated witness within the composite.
class _Witness {
  const _Witness(this.name, this.raw, this.weight, this.floor);

  final String name;
  final double raw;
  final double weight;
  final double floor;
}

/// Internal result of a composite evaluation.
class _CompositeOutcome {
  const _CompositeOutcome({
    required this.score,
    required this.witnesses,
    required this.dominant,
    required this.combiner,
  });

  final double score;
  final Map<String, double> witnesses;
  final String? dominant;
  final CompositeCombiner combiner;
}
