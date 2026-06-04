# Composite ("smart") Similarity - Design

Date: 2026-06-04
Status: Approved (opinionated-robust variant), implementing.

## Problem

Callers do not know which `SimilarityAlgorithm` to pick. The old
`dart_helper_utils` answer was `smartSimilarity`, which **switched** algorithm
based on input shape (length, word count, "looks like code"). That design is
abandoned. Its core flaw: a per-pair algorithm switch produces scores on
different scales, which breaks comparability in the ranking APIs
(`findMatches` / `rankByRelevance` compare one query to many candidates and
sort) and makes a fixed threshold meaningless.

## Decision

Ship a **composite metric**: one stable score that *combines* complementary
witnesses instead of *switching* between them. It is registered as
`SimilarityAlgorithm.composite`, so it flows through every existing API
(`compare`, `findMatches`, `rankByRelevance`, extensions) with no per-call-site
logic. Because the same function scores every pair, scores stay comparable and
ranking is correct. Because all witnesses are always evaluated, there are no
score cliffs.

This is the philosophy of RapidFuzz/FuzzyWuzzy `WRatio`, adapted to pure Dart.

## Witnesses (all already implemented, reused via the same `SimilarityContext`)

| Witness | Covers | Gate |
|---|---|---|
| Jaro-Winkler | typos, transpositions, shared prefix | always |
| Dice (bigram) | mid-word edits, partial char overlap | `minLen >= 2` |
| Cosine (token) | word reordering, multi-word | always |
| Overlap coefficient (trigram) | containment / length disparity | `minLen > ngramSize` |

Gating avoids the empty-gram pathology where short inputs make set metrics
return spurious 1.0. Reusing the engine's `SimilarityContext` means witnesses
share the normalized/bigram/ngram caches (no recomputation).

## Calibration (the "opinionated-robust" part)

Witnesses live on different scales (Jaro-Winkler runs hot, cosine runs cold).
Before combining, each witness is remapped through an empirical noise floor:

```
scaled = clamp01((raw - floor) / (1 - floor))   // raw <= floor maps to 0
```

Floors were derived empirically (not guessed) by scoring 20,000 unrelated
dictionary-word pairs (seeded, reproducible) and taking the 95th percentile of
each witness's noise distribution. Tool: `benchmark/composite_calibration.dart`.

Measured defaults (p95 of unrelated pairs):

| Witness | Floor |
|---|---|
| Jaro-Winkler | 0.63 |
| Dice | 0.22 |
| Cosine | 0.00 |
| Overlap | 0.07 |

## Combiner

`CompositeCombiner` (configurable via `CompositeOptions`):

- `scaledMax` (default): `max(weight_i * scaled(raw_i))`. Calibrated, robust.
- `weightedMean`: `sum(weight_i * scaled(raw_i)) / sum(weight_i)`. Calibrated.
- `max`: `max(weight_i * raw_i)`. Uncalibrated escape hatch.

Weights are "trust factors" (Jaro-Winkler 1.0, Dice 1.0, Cosine 0.95, Overlap
0.9) so a weaker notion of "same" (e.g. containment) cannot alone score 1.0.

## Explainability (removes the "spooky")

`SimilarityResult.metadata` is currently always empty. Add an optional
`ExplainableMetric` interface (`scoreWithDetails` returning score + detail map).
The engine surfaces it from `compareWithDetails`. The composite emits:

```dart
{
  'witnesses': {'jaroWinkler': 0.91, 'cosine': 0.0, ...}, // raw sub-scores
  'combiner': 'scaledMax',
  'dominant': 'jaroWinkler',
}
```

This is additive, opt-in per metric, backward compatible, and finally fills the
dead `metadata` field.

## Surface area

- `SimilarityAlgorithm.composite` (additive enum value).
- `CompositeOptions` + `CompositeCombiner` (in `algorithm_options.dart`,
  exported transitively).
- `ExplainableMetric` + `ExplainedScore` typedef (public extension contract).
- `CompositeMetric` stays internal (used via the enum), consistent with the
  other metric classes.

## Out of scope (deferred, not part of this cut)

- Intent profiles (`SimilarityProfile.names/labels/longText`) - ergonomic
  packaging on top of a validated composite.
- A config-time `recommendAlgorithm(samples)` advisor.
- Dedicated `partialRatio` / `tokenSortRatio` standalone metrics (the existing
  overlap + cosine witnesses already cover containment and reordering for v1).

## Verification

- New `test/similarity/composite_test.dart`: reordering, typo, containment,
  unrelated-suppression, ranking comparability, explainability metadata,
  combiner differences, calibration suppression, options validation.
- `dart analyze` clean, `dart test` green, `dart format` applied.
- Version bump 1.0.1 -> 1.1.0; CHANGELOG, README, example updated.
