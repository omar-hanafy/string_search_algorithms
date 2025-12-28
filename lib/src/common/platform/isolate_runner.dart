import 'isolate_runner_stub.dart'
    if (dart.library.io) 'isolate_runner_io.dart' as impl;

/// Runs [action] in a background isolate if supported (IO), or directly (Web).
Future<R> runInIsolate<R>(R Function() action) {
  return impl.runInIsolate(action);
}
