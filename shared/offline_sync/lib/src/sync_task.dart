/// A feature-owned synchronization operation scheduled by the shared engine.
///
/// The feature keeps ownership of fetching, mapping, transactions and conflict
/// resolution. The base only prevents duplicate runs and reports lifecycle.
abstract interface class SyncTask {
  String get key;

  Future<void> execute();
}

enum SyncPhase { idle, syncing, waitingForNetwork, failed }

class SyncStatus {
  const SyncStatus({
    required this.phase,
    this.taskKey,
    this.error,
  });

  const SyncStatus.idle() : this(phase: SyncPhase.idle);

  final SyncPhase phase;
  final String? taskKey;
  final Object? error;
}
