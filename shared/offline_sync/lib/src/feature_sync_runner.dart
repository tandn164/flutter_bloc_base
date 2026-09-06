import 'dart:async';

import 'sync_task.dart';

/// Runs feature-owned synchronization without allowing the same task to overlap.
class FeatureSyncRunner {
  final _running = <String, Future<void>>{};
  final _status = StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get statuses => _status.stream;

  Future<void> run(SyncTask task) {
    return _running[task.key] ??= _execute(task);
  }

  Future<void> _execute(SyncTask task) async {
    _status.add(SyncStatus(phase: SyncPhase.syncing, taskKey: task.key));
    try {
      await task.execute();
      _status.add(const SyncStatus.idle());
    } catch (error) {
      _status.add(
        SyncStatus(
          phase: SyncPhase.failed,
          taskKey: task.key,
          error: error,
        ),
      );
      rethrow;
    } finally {
      _running.remove(task.key);
    }
  }

  Future<void> dispose() => _status.close();
}
