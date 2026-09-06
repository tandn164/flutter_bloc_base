# Drift Local Storage

Default durable `KeyValueStore` adapter backed by SQLite through Drift.

```dart
final store = DriftKeyValueStore.defaults(name: 'product_app');
await store.writeString('draft', '{"title":"Example"}');
final value = await store.readString('draft');
await store.close();
```

Use this adapter as the ready-to-run storage for generated `DATA=offline-first`
features. It stores each feature payload under a separate key and survives app
restarts.

For large datasets, indexed queries, relations, or partial updates, define
feature-owned Drift tables and DAOs instead of storing a large JSON blob. Keep
the database connection/app initialization in composition and keep business
queries inside the feature data package.

Run code generation after changing tables:

```bash
dart run build_runner build --delete-conflicting-outputs
```
