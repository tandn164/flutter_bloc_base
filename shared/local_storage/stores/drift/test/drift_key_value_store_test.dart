import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_drift/local_storage_drift.dart';

void main() {
  test('reads, replaces, and removes values', () async {
    final store = DriftKeyValueStore(NativeDatabase.memory());
    addTearDown(store.close);

    expect(await store.readString('key'), isNull);
    await store.writeString('key', 'first');
    await store.writeString('key', 'second');
    expect(await store.readString('key'), 'second');
    await store.remove('key');
    expect(await store.readString('key'), isNull);
  });
}
