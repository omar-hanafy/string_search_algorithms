/// Stub isolate runner for platforms where isolates are unavailable or
/// undesired.
///
/// This executes [action] on the current isolate and returns a Future.
Future<R> runInIsolate<R>(R Function() action) async {
  return action();
}
