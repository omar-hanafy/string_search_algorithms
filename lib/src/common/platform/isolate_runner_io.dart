import 'dart:isolate';

/// Runs [action] in a background isolate using [Isolate.run].
///
/// Intended for CPU-heavy work to avoid blocking the main isolate.
/// For web builds, you may want to use a conditional import to swap to
/// `isolate_runner_stub.dart`.
Future<R> runInIsolate<R>(R Function() action) {
  return Isolate.run(action);
}
