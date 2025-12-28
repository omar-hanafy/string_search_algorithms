/// A value paired with an elapsed duration.
class TimedValue<T> {
  /// Creates a [TimedValue].
  const TimedValue(this.value, this.elapsed);

  /// The result value.
  final T value;

  /// The duration it took to produce the value.
  final Duration elapsed;
}

/// Measures synchronous execution time for [action].
TimedValue<T> timeSync<T>(T Function() action) {
  final sw = Stopwatch()..start();
  final value = action();
  sw.stop();
  return TimedValue<T>(value, sw.elapsed);
}

/// Measures asynchronous execution time for [action].
Future<TimedValue<T>> timeAsync<T>(Future<T> Function() action) async {
  final sw = Stopwatch()..start();
  final value = await action();
  sw.stop();
  return TimedValue<T>(value, sw.elapsed);
}
