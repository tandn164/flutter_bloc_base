# Offline Sync

Coordinates feature-owned synchronization. It prevents two runs of the same
`SyncTask` from overlapping and exposes lifecycle status.

```dart
class WorkOrdersSyncTask implements SyncTask {
  WorkOrdersSyncTask(this.repository);
  final WorkOrdersRepository repository;

  @override
  String get key => 'work-orders';

  @override
  Future<void> execute() => repository.synchronize();
}

await FeatureSyncRunner().run(WorkOrdersSyncTask(repository));
```

The feature owns database reads, remote calls, typed pending commands, merge
rules, retries, and conflict resolution. This package does not persist or replay
raw HTTP requests.

## Testing

```bash
dart test shared/offline_sync
```
