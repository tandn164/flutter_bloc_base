import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:local_storage/local_storage.dart';

part 'drift_key_value_store.g.dart';

class LocalValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [LocalValues])
class DriftKeyValueStore extends _$DriftKeyValueStore implements KeyValueStore {
  DriftKeyValueStore(super.executor);

  DriftKeyValueStore.defaults({String name = 'app_local_storage'})
      : super(driftDatabase(name: name));

  @override
  int get schemaVersion => 1;

  @override
  Future<String?> readString(String key) async {
    final row = await (select(localValues)..where((row) => row.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> writeString(String key, String value) {
    return into(localValues).insertOnConflictUpdate(
      LocalValuesCompanion.insert(
        key: key,
        value: value,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> remove(String key) async {
    await (delete(localValues)..where((row) => row.key.equals(key))).go();
  }
}
